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
    let userService: UserServiceProtocol
    
    //Outputs
    @Published var savedAccounts: [SavedAccount] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    init(service: InstagramServiceProtocol, userService: UserServiceProtocol) {
        self.service = service
        self.userService = userService
        loadSavedAccounts()
    }
    
    func loadSavedAccounts() {
        Task {
            do {
                let secrets = try Authenticator.keychain.secrets.get()
                var accounts: [SavedAccount] = []

                for secret in secrets {
                    do {
                        let user = try await userService.fetchUserInfo(secret: secret)
                        let account = SavedAccount(secret: secret, user: user)
                        accounts.append(account)
                    } catch {
                        print("Failed to fetch info for \(secret.identifier): \(error)")
                    }
                }
                savedAccounts = accounts
                errorMessage = nil
            } catch {
                savedAccounts = []
                errorMessage = "Failed to load saved accounts."
            }
        }
    }

    
    func login(from viewController: UIViewController) async {
            isLoading = true
            do {
                let secret = try await service.login(viewController: viewController)
                let user = try await userService.fetchUserInfo(secret: secret)
                let account = SavedAccount(secret: secret, user: user)
                savedAccounts.append(account)
                errorMessage = nil
            } catch {
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
            isLoading = false
        }
}
