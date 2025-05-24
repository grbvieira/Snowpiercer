//
//  FetchNonFollowersUseCase.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//
import Swiftagram
import Foundation

struct UserListViewModelUseCase: UserListViewModelUseCaseProtocol {
    let service: InstagramServiceProtocol
  
    func executeNonFollowers(followers: [InstagramUser], following: [InstagramUser]) -> [InstagramUser] {
        let followersSet = Set(followers.map { $0.username })
        return following.filter { !followersSet.contains($0.username) }
    }
    
    func executeFollowers(secret: Secret) async throws -> [InstagramUser] {
        try await service.fetchFollowers(secret: secret)
        
    }
    
    func executeFollowing(secret: Secret) async throws -> [InstagramUser] {
        try await service.fetchFollowing(secret: secret)
    }
}
