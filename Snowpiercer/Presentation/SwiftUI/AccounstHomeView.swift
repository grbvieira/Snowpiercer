//
//  AccountHomeView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import SwiftUI

struct AccounstHomeView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    @State var isPresentingLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.savedAccounts.isEmpty {
                    Text("Nenhuma conta logada")
                        .foregroundStyle(.secondary)
                        .padding(.top)
                } else {
                    List(viewModel.savedAccounts, id: \ .id) { account in
                        Button {
                            viewModel.select(account: account)
                        } label: {
                            ProfileRowView(user: account.user)
                        }
                    }
                    .listStyle(.sidebar)
                }
                
                Button {
                    isPresentingLoginView = true
                } label: {
                    Text("Login com Instagram")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Contas Salvas")
            .onAppear {
                viewModel.loadSavedAccounts()
            }
            .alert("Erro", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("Fechar", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $isPresentingLoginView) {
                LoginSheet { result in
                    switch result {
                    case .success(let secret):
                        Task {
                            do {
                                let useCase = FetchUserAfterLoginUseCase(userService: viewModel.userService)
                                let account = try await useCase.execute(secret: secret)
                                viewModel.savedAccounts.append(account)
                            } catch {
                                viewModel.errorMessage = "Erro ao buscar dados da conta."
                            }
                        }
                    case .failure(let error):
                        viewModel.errorMessage = "Login falhou: \(error.localizedDescription)"
                    }
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { viewModel.selectedAccount != nil },
                set: { if !$0 { viewModel.selectedAccount = nil } }
            )) {
                if let account = viewModel.selectedAccount {
                    let viewModel = UnfollowersViewModel(useCase: FetchNonFollowersUseCase(service: InstagramService()))
                    NonFollowersView(user: account, viewModel: viewModel)
                }
            }
        }
    }
}

