//
//  InstagramService.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import UIKit
import Swiftagram
import SwiftagramCrypto
import Combine

// MARK: - Services
protocol InstagramServiceProtocol {
    func login(viewController: UIViewController)async throws -> Secret
    func fetchFollowing(secret: Secret) async throws -> [InstagramUser]
    func fetchFollowers(secret: Secret) async throws -> [InstagramUser]
}

class InstagramService: InstagramServiceProtocol {
    
    func login(viewController: UIViewController) async throws -> Secret {
        let loginVC = await InstagramLoginViewController()
        await viewController.present(loginVC, animated: true)
        let secret = try await loginVC.authenticate()
        await viewController.dismiss(animated: true)
        return secret
    }
    
    private var bin: Set<AnyCancellable> = []
    
    func fetchFollowers(secret: Secret) async throws -> [InstagramUser] {
        try await fetchUsers(for: secret, isFollowers: true)
    }
    
    func fetchFollowing(secret: Secret) async throws -> [InstagramUser] {
        try await fetchUsers(for: secret, isFollowers: false)
    }
    
    func fetchUsers(for secret: Secret, isFollowers: Bool) async throws -> [InstagramUser] {
        return try await withCheckedThrowingContinuation { continuation in
            let publisher = isFollowers ? Endpoint.user(secret.identifier).followers : Endpoint.user(secret.identifier).following
            
            publisher
                .unlock(with: secret)
                .session(.instagram)
                .pages(.max)
                .compactMap { $0.users }
                .reduce([], +)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { users in
                    let instagramUsers = users.compactMap { user -> InstagramUser? in
                        guard let username = user.username else { return nil }
                        return InstagramUser(username: username, fullName: user.name, profilePicURL: user.thumbnail, avatar: user.thumbnail)
                    }
                    continuation.resume(returning: instagramUsers)
                })
                .store(in: &self.bin)
        }
    }
}
