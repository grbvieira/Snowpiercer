//
//  UnfollowersViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import UIKit
import Swiftagram
import Combine

@MainActor
final class UserListViewModel: ObservableObject {
    
    let useCase: UserListViewModelUseCaseProtocol
    private(set) var loggedUserSecret: Secret!

    //MARK: - Lista de usuarios
    @Published var followers: [InstagramUser] = []
    @Published var following: [InstagramUser] = []
    @Published var nonFollowers: [InstagramUser] = []
    
    // MARK: - Filtro
    @Published var searchText: String = ""
    @Published var currentType: UserSectionCard = .followers
    @Published private(set) var filteredUsers: [InstagramUser] = []
    
    // MARK: - Estado
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var loadProgress: Double = 0.0
    @Published var challengeURL = "https://instagram.com/"

    
    // MARK: - Controle de Cache
    private(set) var hasLoadedFollowers = false
    private(set) var hasLoadedFollowing = false
    private(set) var hasLoadedNonFollowers = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: UserListViewModelUseCaseProtocol) {
        self.useCase = useCase
        bindSearch()
    }
    
    func setLoggedUser(_ secret: Secret) {
        self.loggedUserSecret = secret
    }
    
    // MARK: - Bind para filtro reativo
    private func bindSearch() {
        Publishers.CombineLatest($searchText, $currentType)
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .map { [weak self] (text, type) -> [InstagramUser] in
                guard let self = self else { return [] }
                
                let list: [InstagramUser]
                switch type {
                case .followers: list = self.followers
                case .following: list = self.following
                case .unfollowers: list = self.nonFollowers
                }
                
                guard !text.isEmpty else { return list }
                
                let lowercasedText = text.lowercased()
                return list.filter {
                    $0.username.lowercased().contains(lowercasedText) ||
                    ($0.fullName?.lowercased().contains(lowercasedText) ?? false)
                }
            }
            .assign(to: &$filteredUsers)
    }
    
    // MARK: - Carregar todos os dados com controle de cache
    func loadAllData(forceReload: Bool = false) async {
        guard let secret = loggedUserSecret else { return }
        
        isLoading = true
        loadProgress = 0.0
        defer {
            isLoading = false
            loadProgress = 1.0
        }
        
        if forceReload {
            self.hasLoadedFollowers = false
            self.hasLoadedFollowing = false
            self.hasLoadedNonFollowers = false
            UserListStorage.shared.clearAll(for: secret.identifier)
        }
        
        async let followersTask: Void = {
            if await !hasLoadedFollowers {
                await loadFollowers(secret: secret)
                await MainActor.run {
                    self.loadProgress += 0.33
                }
            }
        }()
        
        async let followingTask: Void = {
            if await !hasLoadedFollowing {
                await loadFollowing(secret: secret)
                await MainActor.run {
                    self.loadProgress += 0.33
                }
            }
        }()
        
        _ = await (followersTask, followingTask)
        
        if !hasLoadedNonFollowers, hasLoadedFollowers, hasLoadedFollowing {
            loadNonFollowers(secret: secret)
            await MainActor.run {
                self.loadProgress += 0.34
            }
        }
    }
    
    // MARK: - Seguindo
    private func loadFollowing(secret: Secret) async {
        do {
            following = try await useCase.executeFollowing(secret: secret)
            hasLoadedFollowing = true
            UserListStorage.shared.save(following, type: .following, userID: secret.identifier)
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Seguidores
    private func loadFollowers(secret: Secret) async {
        do {
            followers = try await useCase.executeFollowers(secret: secret)
            hasLoadedFollowers = true
            UserListStorage.shared.save(followers, type: .followers, userID: secret.identifier)
        } catch {
            handleError(error)
        }
    }
    // MARK: - Não seguidores
    private func loadNonFollowers(secret: Secret) {
        /// ## Isso é apenas para teste
        guard hasLoadedFollowers, hasLoadedFollowing else {
            errorMessage = "Carregue seguidores e seguindo antes."
            return
        }
        do {
            nonFollowers = useCase.executeNonFollowers(followers: followers, following: following)
            hasLoadedNonFollowers = true
            UserListStorage.shared.save(nonFollowers, type: .unfollowers, userID: secret.identifier)
        }
    }
    
    // MARK: - Carregar do cache local
    func loadCachedLists(secret: Secret) {
        followers = UserListStorage.shared.load(type: .followers, userID: secret.identifier)
        following = UserListStorage.shared.load(type: .following, userID: secret.identifier)
        nonFollowers = UserListStorage.shared.load(type: .unfollowers, userID: secret.identifier)
        hasLoadedFollowers = !followers.isEmpty
        hasLoadedFollowing = !following.isEmpty
        hasLoadedNonFollowers = !nonFollowers.isEmpty
    }
    
    //MARK: - Tratamento de erro genérico
    private func handleError(_ error: Error) {
        if let specializedError = error as? SpecializedError,
           case let .generic(code, response) = specializedError,
           code == "challenge_required" {
            
            let challengeWrapper = response["challenge"]
            if let challenge = challengeWrapper.dictionary() {
                self.errorMessage = "Sua conta precisa passar por um desafio de verificação no Instagram. Volte novamente após o desafio"
            }
        } else {
            self.errorMessage = "Erro: \(error.localizedDescription)"
        }
    }
}
