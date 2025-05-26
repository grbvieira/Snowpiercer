//
//  UnfollowersViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import Combine
import Foundation
import Swiftagram

@MainActor
final class UserListViewModel: ObservableObject, UserListViewModelProtocol {

    // MARK: - Dependencies
    private let useCase: UserListViewModelUseCaseProtocol
    private let storageList: UserListStorageProtocol
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
    private var loggedUserSecret: Secret?
    private var cancellables = Set<AnyCancellable>()
    private var loadTask: Task<Void, Never>?

    // MARK: - Init
    init(
        useCase: UserListViewModelUseCaseProtocol,
        storageList: UserListStorageProtocol,
        parentCoordinatorDelegate: ParentViewModelCoordinatorDelegate? = nil
    ) {
        self.useCase = useCase
        self.storageList = storageList
        self.parentCoordinatorDelegate = parentCoordinatorDelegate
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
    func loadCachedLists() {
        guard let secret = loggedUserSecret else { return }
        loadCachedLists(secret: secret)
    }

    private func loadCachedLists(secret: Secret) {
        followers = storageList.load(
            type: .followers,
            userID: secret.identifier
        )
        following = storageList.load(
            type: .following,
            userID: secret.identifier
        )

        if followers.isEmpty || following.isEmpty {
            nonFollowers = []
        } else {
            let cached = storageList.load(
                type: .unfollowers,
                userID: secret.identifier
            )
            nonFollowers =
                cached.isEmpty
                ? useCase.executeNonFollowers(
                    followers: followers,
                    following: following
                ) : cached
        }

        hasLoadedInitialData = !followers.isEmpty || !following.isEmpty
        updateFilteredUsers()
    }

    func loadUserList(forceReload: Bool) async {
        guard let secret = loggedUserSecret else {
            parentCoordinatorDelegate?.handleError(UserListError.missingSecret)
            return
        }

        if forceReload { clearAPICache() }

        loadTask?.cancel()
        loadTask = Task {
            parentCoordinatorDelegate?.updateProgress(0.0)

            async let followersResult = loadFollowersIfNeeded(secret: secret)
            async let followingResult = loadFollowingIfNeeded(secret: secret)
            let (followersSuccess, followingSuccess) = await (
                followersResult, followingResult
            )

            if followersSuccess && followingSuccess {
                await filterAndStoreNonFollowers(secret: secret)
                parentCoordinatorDelegate?.updateProgress(1.0)
            } else {
                parentCoordinatorDelegate?.updateProgress(-1.0)
            }

            hasLoadedInitialData = true
            loadTask = nil
        }
        await loadTask?.value
    }

    private func loadFollowersIfNeeded(secret: Secret) async -> Bool {
        guard !hasLoadedFollowersFromAPI else {
            parentCoordinatorDelegate?.updateProgress(0.33)
            return true
        }

        return await runSafely {
            let result = try await self.useCase.executeFollowers(secret: secret)
            self.followers = result
            self.hasLoadedFollowersFromAPI = true
            self.storageList.save(
                result,
                type: .followers,
                userID: secret.identifier
            )
            self.parentCoordinatorDelegate?.updateProgress(0.33)
        }
    }

    private func loadFollowingIfNeeded(secret: Secret) async -> Bool {
        guard !hasLoadedFollowingFromAPI else {
            parentCoordinatorDelegate?.updateProgress(0.33)
            return true
        }
        return await runSafely {
            let result = try await self.useCase.executeFollowing(secret: secret)
            self.following = result
            self.hasLoadedFollowingFromAPI = true
            self.storageList.save(
                result,
                type: .following,
                userID: secret.identifier
            )
            self.parentCoordinatorDelegate?.updateProgress(0.33)
        }
    }

    private func filterAndStoreNonFollowers(secret: Secret) async {
        let result = useCase.executeNonFollowers(
            followers: followers,
            following: following
        )
        self.nonFollowers = result
        storageList.save(result, type: .unfollowers, userID: secret.identifier)
        parentCoordinatorDelegate?.updateProgress(0.34)
        updateFilteredUsers()
    }

    private func setupBindings() {
        Publishers.CombineLatest($searchText, $currentListType)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { [weak self] (text, type) -> [InstagramUser] in
                guard let self = self else { return [] }
                let source = self.sourceList(for: type)
                return self.filter(list: source, with: text)
            }
            .assign(to: &$filteredUsers)
    }

    private func updateFilteredUsers() {
        filteredUsers = filter(
            list: sourceList(for: currentListType),
            with: searchText
        )
    }

    private func sourceList(for type: UserSectionCard) -> [InstagramUser] {
        switch type {
        case .followers: return followers
        case .following: return following
        case .unfollowers: return nonFollowers
        }
    }

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

    private func clearAPICache() {
        hasLoadedFollowersFromAPI = false
        hasLoadedFollowingFromAPI = false
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
        -> Bool
    {
        do {
            try await operation()
            return true
        } catch {
            await MainActor.run {
                self.parentCoordinatorDelegate?.handleError(error)
            }
            return false
        }
    }
}
