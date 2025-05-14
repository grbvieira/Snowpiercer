//
//  UnfollowersViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import UIKit
import Swiftagram

@MainActor
final class UserListViewModel: ObservableObject {
    
    let useCase: UserListViewModelUseCaseProtocol
    
    //MARK: - Lista de usuarios
    @Published var followers: [InstagramUser] = []
    @Published var following: [InstagramUser] = []
    @Published var nonFollowers: [InstagramUser] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Controle de Cache
    private(set) var hasLoadedFollowers = false
    private(set) var hasLoadedFollowing = false
    private(set) var hasLoadedNonFollowers = false
    
    init(useCase: UserListViewModelUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // MARK: - Retornar Lista
    func getList(type: UserSectionCard) -> [InstagramUser]{
        switch type {
        case .followers: return followers
        case .following:  return following
        case .unfollowers: return nonFollowers
        }
    }
    
    // MARK: - Carregar todos os dados com controle de cache
    func loadAllData(secret: Secret) async {
        isLoading = true
        defer { isLoading = false }
        
        
        async let followersTask: Void = {
            if await !hasLoadedFollowers {
                await loadFollowers(secret: secret)
            }
        }()
        
        async let followingTask: Void = {
            if await !hasLoadedFollowing {
                await loadFollowing(secret: secret)
            }
        }()
        
        _ = await (followersTask, followingTask)
        
        if !hasLoadedNonFollowers, hasLoadedFollowers, hasLoadedFollowing {
            loadNonFollowers()
        }
    }
    
    // MARK: - Seguindo
    private func loadFollowing(secret: Secret) async {
        do {
            following = try await useCase.executeFollowing(secret: secret)
            hasLoadedFollowing = true
            UserListStorage.shared.save(following, type: .following)
        } catch {
            errorMessage = "Erro ao carregar seguindo: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Seguidores
    private func loadFollowers(secret: Secret) async {
        do {
            followers = try await useCase.executeFollowers(secret: secret)
            hasLoadedFollowers = true
            UserListStorage.shared.save(followers, type: .followers)
        } catch {
            errorMessage = "Erro ao carregar seguindo: \(error.localizedDescription)"
        }
    }
    // MARK: - Não seguidores
    private func loadNonFollowers() {
        /// ## Isso é apenas para teste
        guard hasLoadedFollowers, hasLoadedFollowing else {
            errorMessage = "Carregue seguidores e seguindo antes."
            return
        }
        do {
            nonFollowers = useCase.executeNonFollowers(followers: followers, following: following)
            hasLoadedNonFollowers = false
            UserListStorage.shared.save(nonFollowers, type: .unfollowers)
        }
    }
    
    // MARK: - Carregar do cache local
    func loadCachedLists() {
        followers = UserListStorage.shared.load(type: .followers)
        following = UserListStorage.shared.load(type: .following)
        nonFollowers = UserListStorage.shared.load(type: .unfollowers)
        hasLoadedFollowers = !followers.isEmpty
        hasLoadedFollowing = !following.isEmpty
        hasLoadedNonFollowers = !nonFollowers.isEmpty
    }
}
