//
//  InstagramLoginViewController.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 05/05/25.
//
import UIKit
import Swiftagram
import SwiftagramCrypto
import Combine

class InstagramLoginViewController: UIViewController {
    private var bin = Set<AnyCancellable>()
    func authenticate() async throws -> Secret {
        return try await withCheckedThrowingContinuation { continuation in
            Authenticator.keychain
                .visual(filling: self.view)
                .authenticate()
                .sink { result in
                    switch result{
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { secret in
                    continuation.resume(returning: secret)
                }
                .store(in: &self.bin)
        }
    }
}
