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
    
    init(account: SavedAccount, viewModel: ParentDashboardViewModel) {
        self.account = account
        self.viewModel = viewModel
    }
    
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
//        .toolbar {
//            refreshButton
//        }
        .errorHandling(viewModel: viewModel)
        .task {
            await viewModel.loadInitialData(account: account)
        }
    }
    
    // MARK: - Subviews
    
    private var profileHeader: some View {
        VStack(spacing: 8) {
            AvatarView(size: .max,
                       user: account.user)
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
            ForEach(viewModel.dashboardVM.dashboardCards) { card in
                DashboardCardView(card: card)
                    .onTapGesture {
                        handleCardTap(card)
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
    
    // MARK: - Logic
    private func handleCardTap(_ card: DashboardCard) {
        switch card.id {
        case "followers":
            selectedTab = .followers
        case "following":
            selectedTab = .following
        case "nonFollowers":
            selectedTab = .unfollowers
        default: break
        }
    }
}
