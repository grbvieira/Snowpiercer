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
                        UserRowView(user: user)
                            .padding(.horizontal)
                    }
                }
                .onAppear {
                    viewModel.currentListType = type
                }
                .searchable(text: $viewModel.searchText, prompt: "Username ou nome")
                .navigationTitle(viewModel.currentListType.title)
                .loadingProgressOverlay(viewModel: viewModel)
            }
        }
        .errorHandling(viewModel: viewModel)
    }
}



struct UserRowView: View {
    let user: InstagramUser

    var body: some View {
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
}
