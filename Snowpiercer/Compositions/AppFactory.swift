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
        let viewModel = UserListViewModel(useCase: useCase, storageList: storage)
        return UserDashboardView(account: account, viewModel: viewModel)
    }
    
    static func makeSnowpiercerApp() -> some View {
        let (usecase, storage) = makeLoginDependencies()
        let viewModel = LoginViewModel(useCase: usecase, accountStorage: storage)
        return AccountsHomeView(viewModel: viewModel)
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
