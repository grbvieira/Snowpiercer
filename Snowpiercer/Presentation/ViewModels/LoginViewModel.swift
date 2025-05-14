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
    let usecase: FetchUserAfterLoginUseCase
    
    @Published var savedAccounts: [SavedAccount] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var selectedAccount: SavedAccount?
    
    init(useCase: FetchUserAfterLoginUseCase) {
        self.usecase = useCase
    }
    
    func loadSavedAccounts() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let secrets = try Authenticator.keychain.secrets.get()
                var accounts: [SavedAccount] = []
                
                for secret in secrets {
                    if let cachedUser = AccountStorage.shared.load(for: secret.identifier) {
                        accounts.append(SavedAccount(secret: secret, user: cachedUser))
                    } else {
                        do {
                            let user = try await usecase.execute(secret: secret).user
                            AccountStorage.shared.save(user, for: secret.identifier)
                            accounts.append(SavedAccount(secret: secret, user: user))
                        } catch {
                            print("Erro ao buscar usuário para \(secret.identifier): \(error)")
                        }
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
    
    func delete(account: SavedAccount) {
        usecase.delete(secret: account.secret)
    }
}
