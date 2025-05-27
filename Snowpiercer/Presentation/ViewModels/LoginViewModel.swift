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
class LoginViewModel: ObservableObject {
    let usecase: FetchUserAfterLoginUseCaseProtocol
    private let accountStorage: AccountStorageProtocol
    
    @Published var savedAccounts: [SavedAccount] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var selectedAccount: SavedAccount?
    
    init(useCase: FetchUserAfterLoginUseCaseProtocol,
         accountStorage: AccountStorageProtocol) {
        self.usecase = useCase
        self.accountStorage = accountStorage
    }
    
    func loadSavedAccounts() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let secrets = try Authenticator.keychain.secrets.get()
                var accounts: [SavedAccount] = []
                
                for secret in secrets {
                    if let cachedUser = self.accountStorage.load(for: secret.identifier) {
                        accounts.append(SavedAccount(secret: secret, user: cachedUser))
                    } else {
                        do {
                            let user = try await usecase.execute(secret: secret).user
                            self.accountStorage.save(user, for: secret.identifier)
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
        accountStorage.delete(for: account.secret.identifier)
        savedAccounts.removeAll { $0.secret.identifier == account.secret.identifier }
    }
}

extension LoginViewModel {
    func handleLoginResult(_ result: Result<Secret, Error>) {
        switch result {
        case .success(let secret):
            Task {
                do {
                    let account = try await usecase.execute(secret: secret)
                    if !savedAccounts.contains(where: { $0.secret.identifier == account.secret.identifier }) {
                        savedAccounts.append(SavedAccount(secret: secret, user: account.user))
                        self.accountStorage.save(account.user, for: secret.identifier)
                    }
                } catch {
                    errorMessage = "Erro ao buscar dados da conta."
                }
            }
        case.failure(let error):
            errorMessage = "Login falhou: \(error.localizedDescription)"
        }
    }
}
