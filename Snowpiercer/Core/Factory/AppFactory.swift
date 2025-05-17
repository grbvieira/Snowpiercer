//
//  AppFactory.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 15/05/25.
//

import Foundation
import SwiftUI

final class AppFactory {
    @MainActor
    static func makeUserDashboardView(account: SavedAccount) -> some View {
        let service: InstagramServiceProtocol = InstagramService()
        let useCase: UserListViewModelUseCaseProtocol = UserListViewModelUseCase(service: service)
        let viewModel = UserListViewModel(useCase: useCase)
        return UserDashboardView(account: account,
                                 viewModel: viewModel)
    }
}
