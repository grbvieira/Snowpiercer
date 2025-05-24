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
    //MARK: Remove usuario do keychain e do cache local
    func deleteUser(secret: Swiftagram.Secret) {
        do {
            try Authenticator.keychain.secret(secret.identifier).delete()
        } catch {
            print("Erro ao remover secret do Keychain: \(error)")
        }
    }
    
    //MARK: Pega as informações do usuario salvo no keychain
    func fetchUserInfo(secret: Swiftagram.Secret) async throws -> InstagramUser {
        return try await withCheckedThrowingContinuation { continuation in
            Endpoint.user(secret.identifier)
                .summary
                .unlock(with: secret)
                .session(.instagram)
                .compactMap(\.user)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { user in
                        let account = InstagramUserDTO(from: user)
                        continuation.resume(returning: account.toDomain())
                    }
                )
                .store(in: &self.bin)
        }
    }
    
    private var bin: Set<AnyCancellable> = []
}
