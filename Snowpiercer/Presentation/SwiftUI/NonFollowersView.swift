//
//  NonFollowersView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct NonFollowersView: View {
    
    let user: SavedAccount
    @StateObject var viewModel: UnfollowersViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            SearchBarView(placeholder: "Username ou nome") {
                /// Fazer busca
            }
        }
        .padding(.horizontal)
        
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.nonFollowers, id: \.username) { user in
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
            .navigationTitle("Quem não te segue")
            .task {
                await viewModel.fetchNonFollowers(secret: user.secret)
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
