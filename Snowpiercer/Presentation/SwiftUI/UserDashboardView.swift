//
//  UserDashboardView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct UserDashboardView: View {
    
    let account: SavedAccount
    @State private var selectedTab: UserSectionCard?
    @ObservedObject var viewModel: UserListViewModel
    
    private let gridItems = [
        GridItem(.flexible(minimum: 120, maximum: 200), spacing: 12),
        GridItem(.flexible(minimum: 120, maximum: 200), spacing: 12)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    AvatarView(size: .max,
                               user: account.user)
                    .padding(.top, 32)
                    
                    if let fullName = account.user.fullName {
                        Text(fullName)
                            .font(.title2.bold())
                    }
                    
                    Text("@\(account.user.username)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(UserSectionCard.allCases, id: \ .self) { item in
                        NavigationLink {
                            destinationView(for: item)
                        } label: {
                            DashboardCard(title: item.title, icon: item.icon)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 24)
            }
        }
        .navigationTitle("Visão Geral")
        .overlay {
            if viewModel.isLoading {
                ProgressView("Carregando...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .task {
            viewModel.loadCachedLists()
            await viewModel.loadAllData(secret: account.secret)
        }
    }
    
    @ViewBuilder
    private func destinationView(for item: UserSectionCard) -> some View {
        UserListView(type: item,
                     viewModel: viewModel)
    }
}
