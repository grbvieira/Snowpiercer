//
//  SnowpiercerApp.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI


struct SnowpiercerApp: App {
    var body: some Scene {
        WindowGroup {
            let service = InstagramService()
            let userService = UserService()
            let viewModel = LoginViewModel(service: service, userService: userService)
            AccounstHomeView(viewModel: viewModel)
        }
    }
}
