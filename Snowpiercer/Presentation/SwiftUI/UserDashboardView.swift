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
    @Environment(\.dismiss) private var dismiss

    private let gridItems = [
        GridItem(.flexible(minimum: 120, maximum: 200), spacing: 12),
        GridItem(.flexible(minimum: 120, maximum: 200), spacing: 12)
    ]

    var body: some View {
        ZStack {
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
            .disabled(viewModel.isLoading)
            .blur(radius: viewModel.isLoading ? 3 : 0)

            if viewModel.isLoading {
                LoadingOverlayView(progress: viewModel.loadProgress)
            }
        }
        .navigationTitle("Visão Geral")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await viewModel.loadAllData(forceReload: true)
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .alert("Erro", isPresented: .constant(viewModel.errorMessage != nil)) {
            if let url = viewModel.challengeURL.flatMap(URL.init) {
                Button("Abrir Instagram") {
                    UIApplication.shared.open(url)
                }
            }
            Button("Fechar", role: .cancel) {
                viewModel.errorMessage = nil
                dismiss()
            }
        } message: {
            Text(viewModel.errorMessage ?? "Erro desconhecido")
        }
        .task {
            viewModel.setLoggedUser(account.secret)
            viewModel.loadCachedLists(secret: account.secret)
            await viewModel.loadAllData()
        }
    }

    @ViewBuilder
    private func destinationView(for item: UserSectionCard) -> some View {
        UserListView(type: item, viewModel: viewModel)
    }
}
