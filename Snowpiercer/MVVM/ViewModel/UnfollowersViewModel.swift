//
//  UnfollowersViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import UIKit
import Swiftagram

// MARK: - ViewModel
@MainActor
final class UnfollowersViewModel: ObservableObject {
    private let service: InstagramServiceProtocol
    
    @Published private(set) var nonFollowers: [InstagramUser] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    init(service: InstagramServiceProtocol) {
        self.service = service
    }
    
    func fetchNonFollowers(secret: Secret) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let following = try await service.fetchFollowing(secret: secret)
            let followers = try await service.fetchFollowers(secret: secret)
            
            let followersSet = Set(followers.map {$0.username})
            nonFollowers = followers.filter{ !followersSet.contains($0.username)}
        } catch {
            errorMessage = "Failed to fetch users: \(error.localizedDescription)"
            nonFollowers = []
        }
        isLoading = false
    }
    /*  private let service: InstagramServiceProtocol
    private(set) var nonFollowers: [InstagramUser] = []

    init(service: InstagramServiceProtocol) {
        self.service = service
    }

    func fetchNonFollowers(secret: Secret) async throws {
        let following = try await service.fetchFollowing(secret: secret)
        let followers = try await service.fetchFollowers(secret: secret)

        let followersSet = Set(followers.map { $0.username })
        self.nonFollowers = following.filter { !followersSet.contains($0.username) }
    }
   */
}
