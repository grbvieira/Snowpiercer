//
//  SnowpiercerApp.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

@main
struct SnowpiercerApp: App {
    var body: some Scene {
        WindowGroup {
            let userService = UserService()
            let usecase = FetchUserAfterLoginUseCase(userService: userService)
            let viewModel = LoginViewModel(useCase: usecase)
            AccounstHomeView(viewModel: viewModel)
        }
    }
}
