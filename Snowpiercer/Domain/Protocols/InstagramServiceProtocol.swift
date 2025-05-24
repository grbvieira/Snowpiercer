//
//  InstagramServiceProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import Swiftagram

protocol InstagramServiceProtocol {
    func fetchFollowing(secret: Secret) async throws -> [InstagramUser]
    func fetchFollowers(secret: Secret) async throws -> [InstagramUser]
}
