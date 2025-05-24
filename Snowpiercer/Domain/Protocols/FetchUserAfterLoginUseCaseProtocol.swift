//
//  FetchUserAfterLoginUseCaseProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 24/05/25.
//

import Swiftagram

protocol FetchUserAfterLoginUseCaseProtocol {
    func execute(secret: Secret) async throws -> SavedAccount
    func delete(secret: Secret)
}
