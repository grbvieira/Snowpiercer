//
//  UserServiceProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import Swiftagram

protocol UserServiceProtocol {
    func fetchUserInfo(secret: Secret) async throws -> InstagramUser
    func deleteUser(secret: Secret)
}
