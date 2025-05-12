//
//  LoginViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 07/05/25.
//


import UIKit
import SwiftUI
import Swiftagram

@MainActor
final class LoginViewModel: ObservableObject {
    let service: InstagramServiceProtocol
    let userService: UserServiceProtocol
    
    @Published var savedAccounts: [SavedAccount] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var selectedAccount: SavedAccount?
    
    init(service: InstagramServiceProtocol, userService: UserServiceProtocol) {
        self.service = service
        self.userService = userService
    }
    
    func loadSavedAccounts() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let secrets = try Authenticator.keychain.secrets.get()
                var accounts: [SavedAccount] = []
                
                for secret in secrets {
                    do {
                        let user = try await userService.fetchUserInfo(secret: secret)
                        accounts.append(SavedAccount(secret: secret, user: user))
                    } catch {
                        print("Erro ao buscar usuário para \(secret.identifier): \(error)")
                    }
                }
                savedAccounts = accounts
            } catch {
                savedAccounts = []
                errorMessage = "Failed to load saved accounts."
            }
        }
    }
    
    func select(account: SavedAccount) {
        selectedAccount = account
    }
}
