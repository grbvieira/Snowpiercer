//
//  UserDashboardView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct UserDashboardView: View {
    let user: InstagramUser
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
            .loadingProgressOverlay(viewModel: viewModel.userListViewModel as! UserListViewModel)
        }
        .toolbar{
            refreshButton
        }
        .navigationTitle("Visão Geral")
        .errorHandling(viewModel: viewModel.userListViewModel as! UserListViewModel)
        .task {
            await viewModel.loadInitialData()
        }
    }
    
    // MARK: - Subviews
    
    private var profileHeader: some View {
        VStack(spacing: 8) {
            AvatarView(size: .max, user: user)
                .padding(.top, 32)
            
            if let fullName = user.fullName {
                Text(fullName)
                    .font(SnowpiercerFont.heading())
            }
            
            Text("@\(user.username)")
                .font(SnowpiercerFont.body())
                .foregroundColor(.snowpiercerSecondaryText)
        }
    }
    
    private var cardGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
            ForEach(viewModel.dashboardCards) { card in
                NavigationLink(destination: AppFactory.makeDestination(for: card,
                                                                       using: viewModel.userListViewModel as! UserListViewModel)) {
                    let count = returnCount(card: card)
                    DashboardCardView(card: card, count: count)
                }
            }
        }
        .padding()
    }
    
    private func returnCount(card: DashboardCard) -> Int{
        switch card.id {
        case "followers": return viewModel.userListViewModel.followers.count
        case "following": return viewModel.userListViewModel.following.count
        case "nfollowers": return viewModel.userListViewModel.nonFollowers.count
        default: return 0
        }
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
