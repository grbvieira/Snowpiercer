//
//  AppFactory.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 15/05/25.
//

import Foundation
import SwiftUI

@MainActor
final class AppFactory {
    
    static func makeUserDashboardView(account: SavedAccount) -> some View {
        let (useCase, storage) = makeUserListDependencies()
        let dashVM = UserDashboardViewModel()
        let listVM = UserListViewModel(useCase: useCase, storageList: storage, account: account)
        let viewModel = ParentDashboardViewModel(userDashboardViewModel: dashVM,
                                                 userListViewModel: listVM)
        return UserDashboardView(user: account.user, viewModel: viewModel)
    }
    
    static func makeSnowpiercerApp() -> some View {
        let (usecase, storage) = makeLoginDependencies()
        let viewModel = LoginViewModel(useCase: usecase, accountStorage: storage)
        return AccountsHomeView(viewModel: viewModel)
    }
    
    @ViewBuilder
    static func makeDestination(for card: DashboardCard, using viewModel: UserListViewModel) -> some View {
        switch card.id {
        case "followers":
            UserListView(type: .followers, viewModel: viewModel)
        case "following":
            UserListView(type: .following, viewModel: viewModel)
        case "nonFollowers":
            UserListView(type: .unfollowers, viewModel: viewModel)
        case "stories":
            Text("Stories View")
        case "media":
            Text("Media View")
        default:
            EmptyView()
        }
    }

    // MARK: - Métodos auxiliares
    
    private static func makeUserListDependencies() -> (UserListViewModelUseCaseProtocol, UserListStorageProtocol) {
        let service = InstagramService()
        let useCase = UserListViewModelUseCase(service: service)
        let storage = UserListStorage()
        return (useCase, storage)
    }
    
    private static func makeLoginDependencies() -> (FetchUserAfterLoginUseCaseProtocol, AccountStorageProtocol) {
        let service = UserService()
        let useCase = FetchUserAfterLoginUseCase(userService: service)
        let storage = AccountStorage()
        return (useCase, storage)
    }
}
