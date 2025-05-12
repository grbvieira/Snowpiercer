//
//  FetchNonFollowersUseCaseProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//
import Swiftagram

protocol FetchNonFollowersUseCaseProtocol {
    func execute(secret: Secret) async throws -> [InstagramUser]
}
