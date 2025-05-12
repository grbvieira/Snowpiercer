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
        List(viewModel.nonFollowers, id: \ .username) { user in
            HStack {
             ProfileRowView(user: user)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Quem não te segue")
        .onAppear {
            viewModel.fetchNonFollowers(secret: user.secret)
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
