//
//  FetchNonFollowersUseCase.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//
import Swiftagram
import Foundation

struct FetchNonFollowersUseCase {
    let service: InstagramServiceProtocol

    func execute(secret: Secret) async throws -> [InstagramUser] {
        let following = try await service.fetchFollowing(secret: secret)
        let followers = try await service.fetchFollowers(secret: secret)

        let followersSet = Set(followers.map { $0.username })
        return following.filter { !followersSet.contains($0.username) }
    }
}
