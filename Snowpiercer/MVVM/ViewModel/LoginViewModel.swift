//
//  LoginViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 07/05/25.
//


import UIKit
import Swiftagram

@MainActor
final class LoginViewModel {
    let service: InstagramServiceProtocol
    
    //Outputs
    @Published var savedSecrets: [Secret] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init(service: InstagramServiceProtocol) {
        self.service = service
        loadSavedAccounts()
    }
    
    func loadSavedAccounts() {
        do {
            let secrets = try Authenticator.keychain.secrets.get()
            savedSecrets = secrets
        } catch {
            savedSecrets = []
            errorMessage = "Failed to load saved account"
        }
    }
    
    func login(from viewController: UIViewController) async {
        isLoading = true
        do {
            let secret = try await service.login(viewController: viewController)
            savedSecrets.append(secret)
            errorMessage = nil
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
