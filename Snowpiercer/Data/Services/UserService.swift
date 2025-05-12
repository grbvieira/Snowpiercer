//
//  UserService.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 10/05/25.
//

import Combine
import Swiftagram
import UIKit

class UserService: UserServiceProtocol {
    private var bin: Set<AnyCancellable> = []  
    func fetchUserInfo(secret: Swiftagram.Secret) async throws -> InstagramUser {
        return try await withCheckedThrowingContinuation { continuation in
            Endpoint.user(secret.identifier)
                .summary
                .unlock(with: secret)
                .session(.instagram)
                .compactMap(\.user)
                .sink(receiveCompletion: { _ in },
                      receiveValue: { user in
                    let account = InstagramUserDTO(from: user)
                    continuation.resume(returning: account.toDomain())
                })
                .store(in: &self.bin)
        }
    }
}
