//
//  UnfollowersViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import UIKit
import Swiftagram

@MainActor
final class UserListViewModel: ObservableObject {
    let useCase: UserListViewModelUseCaseProtocol
    let type: UserSectionCard
    
    @Published var users: [InstagramUser] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(type: UserSectionCard, useCase: UserListViewModelUseCaseProtocol) {
        self.type = type
        self.useCase = useCase
    }

    func fetch(secret: Secret) async {
        isLoading = true
        defer { isLoading = false }
        do {
            switch type {
            case .followers:
                users = try await useCase.executeFollowers(secret: secret)
            case .following:
                users = try await useCase.executeFollowing(secret: secret)
            case .unfollowers:
                users = try await useCase.executeNonFollowers(secret: secret)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
