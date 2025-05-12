//
//  InstagramLoginViewController.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 05/05/25.
//
import UIKit
import Swiftagram
import Combine
import SwiftUI

class LoginViewController: UIViewController {
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

struct LoginSheet: UIViewControllerRepresentable {
    let completion: (Result<Secret, Error>) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        let placeholder = UIViewController()
        DispatchQueue.main.async {
            Task {
                do {
                    let loginVC = LoginViewController()
                    let secret = try await loginVC.authenticate()
                    completion(.success(secret))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        return placeholder
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
