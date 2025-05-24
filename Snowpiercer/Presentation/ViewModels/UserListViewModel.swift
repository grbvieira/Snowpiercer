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
final class UserListViewModel: ObservableObject, @preconcurrency ErrorHandlingViewModel{

    // MARK: - Dependencies
    let useCase: UserListViewModelUseCaseProtocol
    private(set) var loggedUserSecret: Secret!
    private let storageList: UserListStorageProtocol
    
    // MARK: - Published Properties (UI state)
    /// List user
    @Published var followers: [InstagramUser] = []
    @Published var following: [InstagramUser] = []
    @Published var nonFollowers: [InstagramUser] = []
    
    /// filter
    @Published var searchText: String = ""
    @Published var currentType: UserSectionCard = .followers
    @Published private(set) var filteredUsers: [InstagramUser] = []
    
    /// State
    @Published var isLoading = false
    @Published var loadProgress: Double = 0.0
    @Published var errorMessage: String?
    @Published var challengeURL: String?
    
    // MARK: - Cache Control
    private(set) var hasLoadedFollowers = false
    private(set) var hasLoadedFollowing = false
    private(set) var hasLoadedNonFollowers = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(useCase: UserListViewModelUseCaseProtocol, storageList: UserListStorageProtocol) {
        self.useCase = useCase
        self.storageList = storageList
        setupBindings()
    }
    
    // MARK: - Public Methods
    func setLoggedUser(_ secret: Secret) {
        self.loggedUserSecret = secret
    }
    
    func prepareDashboard(with secret: Secret) async {
        setLoggedUser(secret)
        loadCachedLists(secret: secret)
        await loadAllData()
    }

    
    // MARK: - Carregar do cache local
   private  func loadCachedLists(secret: Secret) {
        followers = storageList.load(type: .followers, userID: secret.identifier)
        following = storageList.load(type: .following, userID: secret.identifier)
        nonFollowers = storageList.load(type: .unfollowers, userID: secret.identifier)
        
        hasLoadedFollowers = !followers.isEmpty
        hasLoadedFollowing = !following.isEmpty
        hasLoadedNonFollowers = !nonFollowers.isEmpty
    }
    
    // MARK: - Carregar todos os dados com controle de cache
     func loadAllData(forceReload: Bool = false) async {
        guard let secret = loggedUserSecret else { return }
        
        isLoading = true
        loadProgress = 0.0
        errorMessage = nil
        challengeURL = nil
        
        if forceReload {
            clearCaches(for: secret)
        }
        
        await loadFollowersAndFollowing(secret: secret)
        await loadNonFollowers()
        
        isLoading = false
        loadProgress = 1.0
    }
    
    // MARK: - Bind para filtro reativo
    
    private func setupBindings() {
        Publishers.CombineLatest($searchText, $currentType)
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .map { [weak self] (text, type) in
                self?.filteredUsers(searchText: text, type: type) ?? []
            }
            .assign(to: &$filteredUsers)
    }
    
    private func filteredUsers(searchText: String, type: UserSectionCard) -> [InstagramUser] {
        let sourceList: [InstagramUser] = {
            switch type {
            case .followers: return followers
            case .following: return following
            case .unfollowers: return nonFollowers
            }
        }()
        
        guard !searchText.isEmpty else { return sourceList }
        let lowercasedText = searchText.lowercased()
        return sourceList.filter {
            $0.username.lowercased().contains(lowercasedText) ||
            ($0.fullName?.lowercased().contains(lowercasedText) ?? false)
        }
    }
    
    private func clearCaches(for secret: Secret) {
        hasLoadedFollowers = false
        hasLoadedFollowing = false
        hasLoadedNonFollowers = false
        
        storageList.clearAll(for: secret.identifier)
    }
    
    private func loadFollowersAndFollowing(secret: Secret) async {
        async let followersTask: () = loadFollowers(secret: secret)
        async let followingTask: () = loadFollowing(secret: secret)
        _ = await (followersTask, followingTask)
    }
    
    // MARK: - Seguindo
    private func loadFollowing(secret: Secret) async {
        guard !hasLoadedFollowing else { return }
        
        await runSafely {
            self.following = try await self.useCase.executeFollowing(secret: secret)
            self.hasLoadedFollowing = true
            self.storageList.save(self.following, type: .following, userID: secret.identifier)
            await MainActor.run { self.loadProgress += 0.33 }
        }
        
    }
    
    // MARK: - Seguidores
    private func loadFollowers(secret: Secret) async {
        guard !hasLoadedFollowers else { return }
        
        await runSafely {
            self.followers = try await self.useCase.executeFollowers(secret: secret)
            self.hasLoadedFollowers = true
            self.storageList.save(self.followers, type: .followers, userID: secret.identifier)
            await MainActor.run { self.loadProgress += 0.33 }
        }
    }
    
    // MARK: - Não seguidores
    private func loadNonFollowers() async {
        guard !hasLoadedNonFollowers, hasLoadedFollowers, hasLoadedFollowing else { return }
        
        nonFollowers = useCase.executeNonFollowers(followers: followers, following: following)
        hasLoadedNonFollowers = true
        storageList.save(nonFollowers, type: .unfollowers, userID: loggedUserSecret.identifier)
        await MainActor.run { loadProgress += 0.34}
    }
    
    private func runSafely(_ operation: @escaping () async throws -> Void) async {
        do {
            try await operation()
        } catch {
            await MainActor.run {
                self.handleError(error)
            }
        }
    }
    
    //MARK: - Tratamento de erro genérico
    private func handleError(_ error: Error) {
        if let specializedError = error as? SpecializedError,
           case let .generic(code, response) = specializedError,
           code == "challenge_required" {
            
            let challengeWrapper = response["challenge"]
            if challengeWrapper.dictionary() != nil {
                self.challengeURL = "https://instagram.com/"
                self.errorMessage = "Sua conta precisa passar por um desafio de verificação no Instagram. Volte novamente após o desafio"
            }
        } else {
            self.errorMessage = "Erro: \(error.localizedDescription)"
        }
    }
}
