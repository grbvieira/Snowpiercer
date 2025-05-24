//
//  FetchUserAfterLoginUseCase.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import Foundation
import Swiftagram
// FIX: Passar para pasta correta
protocol FetchUserAfterLoginUseCaseProtocol {
    func execute(secret: Secret) async throws -> SavedAccount
    func delete(secret: Secret)
}

struct FetchUserAfterLoginUseCase: FetchUserAfterLoginUseCaseProtocol {
    let userService: UserServiceProtocol

    func execute(secret: Secret) async throws -> SavedAccount {
        let user = try await userService.fetchUserInfo(secret: secret)
        return SavedAccount(secret: secret, user: user)
    }
    
    func delete(secret: Secret) {
        userService.deleteUser(secret: secret)
    }
}
