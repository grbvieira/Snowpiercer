//
//  AccountHomeView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import SwiftUI

struct AccountsHomeView: View {
    
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
                    Spacer()
                    ForEach(viewModel.savedAccounts, id: \.id) { account in
                        Button {
                            viewModel.select(account: account)
                        } label: {
                            ProfileRowView(user: account.user,
                                           display: .home)
                        }
                        .background(Color.snowpiercerCard)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
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
            .toolbarTitleDisplayMode(.inline)
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
                    viewModel.handleLoginResult(result)
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { viewModel.selectedAccount != nil },
                set: { if !$0 { viewModel.selectedAccount = nil } }
            )) {
                if let account = viewModel.selectedAccount {
                    AppFactory.makeUserDashboardView(account: account)
                }
            }
            .background(Color.snowpiercerBackground)
        }
    }
}
