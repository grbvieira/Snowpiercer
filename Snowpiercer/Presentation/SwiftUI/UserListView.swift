//
//  NonFollowersView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct UserListView: View {
    
    let user: SavedAccount
    private var title: String
    let type: UserSectionCard
    
    @StateObject var viewModel: UserListViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            SearchBarView(placeholder: "Username ou nome") {
                /// Fazer busca
            }
        }
        .padding(.horizontal)
        
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.users, id: \.username) { user in
                    HStack {
                        ProfileRowView(user: user)
                        
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
            }
            .padding(.horizontal)
            .navigationTitle(title)
            .task {
                await viewModel.fetch(secret: user.secret)
            }
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
