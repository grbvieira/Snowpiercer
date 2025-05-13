//
//  FetchNonFollowersUseCaseProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//
import Swiftagram

protocol UserListViewModelUseCaseProtocol {
    func executeNonFollowers(secret: Secret) async throws -> [InstagramUser]
    func executeFollowers(secret: Secret) async throws -> [InstagramUser]
    func executeFollowing(secret: Secret) async throws -> [InstagramUser]
}
