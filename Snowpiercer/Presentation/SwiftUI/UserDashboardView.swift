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
    var viewModel: any ParentDashboardViewModelProtocol
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    cardGrid
                }
            }
            .disabled(viewModel.isLoading)
            .blur(radius: viewModel.isLoading ? 3 : 0)
            
            if viewModel.isLoading {
                LoadingOverlayView(progress: viewModel.loadProgress)
            }
        }
        .navigationTitle("Visão Geral")
        .errorHandling(viewModel: viewModel as! ParentDashboardViewModel)
        .task {
            await viewModel.loadInitialData(account: account)
        }
    }
    
    // MARK: - Subviews
    
    private var profileHeader: some View {
        VStack(spacing: 8) {
            AvatarView(size: .max, user: account.user)
                .padding(.top, 32)
            
            if let fullName = account.user.fullName {
                Text(fullName)
                    .font(SnowpiercerFont.heading())
            }
            
            Text("@\(account.user.username)")
                .font(SnowpiercerFont.body())
                .foregroundColor(.snowpiercerSecondaryText)
        }
    }
    
    private var cardGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
            ForEach(viewModel.dashboardCards) { card in
                NavigationLink(destination: AppFactory.makeDestination(for: card,
                                                                       using: viewModel.userListViewModel as! UserListViewModel)) {
                    DashboardCardView(card: card)
                }
            }
        }
        .padding()
    }
    
    private var refreshButton: some View {
        Button(action: refreshData) {
            Image(systemName: "arrow.clockwise")
        }
    }
    
    // MARK: - Action
    
    private func refreshData() {
        Task {
            await viewModel.refreshData()
        }
    }
    
}
