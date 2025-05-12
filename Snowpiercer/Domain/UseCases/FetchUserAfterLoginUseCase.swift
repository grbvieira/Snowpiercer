//
//  FetchUserAfterLoginUseCase.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import Foundation
import Swiftagram

struct FetchUserAfterLoginUseCase {
    let userService: UserServiceProtocol

    func execute(secret: Secret) async throws -> SavedAccount {
        let user = try await userService.fetchUserInfo(secret: secret)
        return SavedAccount(secret: secret, user: user)
    }
}
