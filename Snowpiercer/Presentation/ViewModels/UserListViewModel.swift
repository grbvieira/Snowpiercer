//
//  UnfollowersViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import Combine
import Swiftagram

@MainActor
final class UserListViewModel: ObservableObject, @preconcurrency
    UserListViewModelProtocol
{
    func loadUserList(forceReload: Bool) async {}
    func loadCachedLists() {}

    // MARK: - Dependencies
    private let useCase: UserListViewModelUseCaseProtocol
    private let storageList: UserListStorageProtocol
    ///Fazer Estudo de caso para subistituir por combine
    private weak var parentCoordinatorDelegate:
        ParentViewModelCoordinatorDelegate?

    // MARK: - Published Properties (UI state)
    @Published private(set) var followers: [InstagramUser] = []
    @Published private(set) var following: [InstagramUser] = []
    @Published private(set) var nonFollowers: [InstagramUser] = []
    @Published var searchText: String = ""
    @Published var currentListType: UserSectionCard = .followers
    @Published private(set) var filteredUsers: [InstagramUser] = []
    @Published private(set) var hasLoadedInitialData: Bool = false

    // MARK: - Cache Control
    private var hasLoadedFollowersFromAPI = false
    private var hasLoadedFollowingFromAPI = false

    // MARK: - Internal State
    private var loggedUserSecret: Secret?  // Armazena o segredo do usuario logado
    private var cancellables = Set<AnyCancellable>()  // gerencia subscriptions do combine
    private var loadTask: Task<Void, Never>?  // gerencia a tarefa de carregamento concorrent

    // MARK: - Init
    init(
        useCase: UserListViewModelUseCaseProtocol,
        storageList: UserListStorageProtocol
    ) {
        self.useCase = useCase
        self.storageList = storageList
        setupBindings()
    }

    // MARK: - Setup
    func setup(with secret: Secret) {
        guard self.loggedUserSecret!.identifier != secret.identifier else {
            return
        }
        self.loggedUserSecret = secret
        resetLocalState()
        loadCachedLists()

    }

    // MARK: - Carregar do cache local
    private func loadCachedLists(secret: Secret) {
        let cachedFollowers = storageList.load(
            type: .followers,
            userID: secret.identifier
        )
        
        let cachedFollowing = storageList.load(
            type: .following,
            userID: secret.identifier
        )
        let cachedNonFollowers = storageList.load(
            type: .unfollowers,
            userID: secret.identifier
        )

        if !cachedFollowers.isEmpty && !hasLoadedFollowersFromAPI {
            self.followers = cachedFollowers
        }

        if !cachedFollowing.isEmpty && !hasLoadedFollowingFromAPI {
            self.following = cachedFollowing
        }

        if !cachedFollowing.isEmpty && !cachedFollowers.isEmpty {
            if cachedNonFollowers.isEmpty {
                self.nonFollowers = useCase.executeNonFollowers(
                    followers: self.followers,
                    following: self.following
                )
            } else {
                self.nonFollowers = cachedNonFollowers
            }
        }

        self.hasLoadedInitialData =
            !self.followers.isEmpty || !self.following.isEmpty
        updateFilteredUsers()
    }

    // MARK: - Carregar todos os dados com controle de cache
    func loadUserLists(forceReload: Bool = false) async {
        guard let secret = loggedUserSecret else {
            await parentCoordinatorDelegate?.handleError(
                UserListError.missingSecret
            )
            return
        }

        loadTask?.cancel()

        loadTask = Task {
            await parentCoordinatorDelegate?.updateProgress(0.0)

            if forceReload {
                clearAPICache()
            }

            async let followersResult = loadFollowersFromAPIIfNeeded(
                secret: secret
            )
            async let followingResult = loadFollowingFromAPIIfNeeded(
                secret: secret
            )

            let (followersSuccess, followingSuccess) = await (
                followersResult, followingResult
            )

            if followersSuccess && followingSuccess {
                await filterAndStoreNonFollowers(secret: secret)
                await parentCoordinatorDelegate?.updateProgress(1.0)
            } else {
                await parentCoordinatorDelegate?.updateProgress(-1.0)
            }

            self.hasLoadedInitialData = true
            self.loadTask = nil
        }
        await loadTask?.value
    }

    //MARK: - Private Loading Helpers

    // MARK: - Following from the API if needed
    private func loadFollowingFromAPIIfNeeded(secret: Secret) async -> Bool {
        guard !hasLoadedFollowingFromAPI else {
            await parentCoordinatorDelegate?.updateProgress(0.33)
            return true
        }

        await runSafely {
            let fechedFollowing = try await self.useCase.executeFollowing(
                secret: secret
            )
            self.following = fechedFollowing
            self.hasLoadedFollowingFromAPI = true
            self.storageList.save(
                self.following,
                type: .following,
                userID: secret.identifier
            )
            await self.parentCoordinatorDelegate?.updateProgress(0.33)
        }

    }

    // MARK: - Follower from the API if needed
    private func loadFollowersFromAPIIfNeeded(secret: Secret) async -> Bool {
        guard !hasLoadedFollowingFromAPI else {
            await parentCoordinatorDelegate?.updateProgress(0.33)
            return true
        }

        await runSafely {
            let fechedFollower = try await self.useCase.executeFollowers(
                secret: secret
            )
            self.hasLoadedFollowersFromAPI = true
            self.storageList.save(
                self.following,
                type: .followers,
                userID: secret.identifier
            )
            await self.parentCoordinatorDelegate?.updateProgress(0.33)
        }

    }

    // MARK: - Filters and stores the list of unfollowers
    private func filterAndStoreNonFollowers(secret: Secret) async {
        guard hasLoadedFollowingFromAPI, hasLoadedFollowersFromAPI else {
            return
        }

        let filterNonFollowers = useCase.executeNonFollowers(
            followers: followers,
            following: following
        )
        
        self.nonFollowers = filterNonFollowers
        storageList.save(
            self.nonFollowers,
            type: .unfollowers,
            userID: secret.identifier
        )
        
        await parentCoordinatorDelegate?.updateProgress(0.34)
        updateFilteredUsers()
    }

    // MARK: - Combine bindings for reactively filtering
    private func setupBindings() {
        Publishers.CombineLatest($searchText, $currentListType)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { [weak self] (text, type) -> [InstragramUser] in
                guard let self = self else { return [] }
                let sourceList = self.sourceList(for: type)
                return self.filter(list: sourceList, with: text)

            }
            .assign(to: &filteredUsers)
    }

    // MARK: - Manually refresh the filtered list (used after uploads)
    private func updateFilteredUsers() {
        let sourceList = self.sourceList(for: currentType)
        self.filteredUsers = self.filter(list: sourceList, with: searchText)
    }

    // MARK: - Returns the source list based on the selected type
    private func sourceList(for type: UserSectionCard) -> [InstagramUser] {
        switch type {
        case .followers: return followers
        case .following: return following
        case .unfollowers: return nonFollowers
        }
    }

    //MARK: -  Filter based on the text
    private func filter(list: [InstagramUser], with text: String)
        -> [InstagramUser]
    {
        guard !text.isEmpty else { return list }
        let lowercasedText = text.lowercased()

        return list.filter {
            $0.username.lowercased().contains(lowercasedText)
                || ($0.fullName?.lowercased().contains(lowercasedText) ?? false)
        }
    }

    //MARK: State Mamagement
    private func clearAPICache() {
        hasLoadedFollowersFromAPI = false
        hasLoadedFollowingFromAPI = false
        ///Limpar cache do youser default?
        //  storageList.clearAll(for: secret.identifier)
    }

    private func resetLocalState() {
        followers = []
        following = []
        nonFollowers = []
        filteredUsers = []
        hasLoadedInitialData = false
        clearAPICache()
    }

    private func runSafely(_ operation: @escaping () async throws -> Void) async
    {
        do {
            try await operation()
        } catch {
            await MainActor.run {
                self.parentCoordinatorDelegate?.handleError(error)
            }
        }
    }
}
