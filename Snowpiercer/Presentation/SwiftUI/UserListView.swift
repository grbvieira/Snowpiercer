//
//  NonFollowersView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct UserListView: View {
    
    let type: UserSectionCard
    
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("\(viewModel.filteredUsers.count)")
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredUsers, id: \.username) { user in
                        HStack {
                            ProfileRowView(user: user, display: .list)
                            
                            FollowButton {
                                if let url = URL(string: "https://instagram.com/\(user.username)") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .onAppear{
                    viewModel.currentType = type
                }
                .searchable(text: $viewModel.searchText, prompt: "Username ou nome")
                .navigationTitle(viewModel.currentType.title)
                .overlay {
                    if viewModel.isLoading {
                        ProgressView("Carregando...")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
                .alert("Erro", isPresented: .constant(viewModel.errorMessage != nil)) {
                    Button("Fechar", role: .cancel) {}
                } message: {
                    Text(viewModel.errorMessage ?? "Erro desconhecido")
                }
            }
        }
    }
}
