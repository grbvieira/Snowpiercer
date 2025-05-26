//
//  ParentDashboardViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 23/05/25.
//

import Combine
import SwiftUI
import Swiftagram

@MainActor
class ParentDashboardViewModel: ObservableObject, ParentDashboardViewModelProtocol {
    
    //MARK: - Child ViewModels
    let userDashboardViewModel: any UserDashboardViewModelProtocol
    let userListViewModel: any UserListViewModelProtocol
    var dashboardCards: [DashboardCard] {
        userDashboardViewModel.dashboardCards
    }
    
    //MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var loadProgress: Double = 0.0
    @Published var errorMessage: String? = nil
    @Published var challengeURL: String? = nil
    
    init(userDashboardViewModel: any UserDashboardViewModelProtocol, userListViewModel: any UserListViewModelProtocol) {
        self.userDashboardViewModel = userDashboardViewModel
        self.userListViewModel = userListViewModel
    }
    
    // MARK: - Load Initial Data
    func loadInitialData(account: SavedAccount) async {
        isLoading = true
        loadProgress = 0.0
        errorMessage = nil
        errorMessage = nil
        
        defer {
            isLoading = false
            loadProgress = 0.0
        }
        
        async let setupTask: () = userListViewModel.setup(with: account.secret)
        async let loadListTask: () = userListViewModel.loadUserList(forceReload: false)
        _ = await (setupTask, loadListTask)
    }
    
    // MARK: Update Data
    func refreshData() async {
        isLoading = true
        loadProgress = 0.0
        
        defer {
            isLoading = false
            loadProgress = 1.0
        }
        
        await userListViewModel.loadUserList(forceReload: true)
    }
}

extension ParentDashboardViewModel: ParentViewModelCoordinatorDelegate {
    func updateProgress(_ progress: Double) {
        self.loadProgress = progress
    }
    
    func handleError(_ error: any Error) {
        if let specializedError = error as? SpecializedError,
           case let .generic(code, response) = specializedError,
           code == "challenge_required" {
            
            let challengeWrapper = response["challenge"]
            if challengeWrapper.dictionary() != nil {
                self.challengeURL = "https://instagram.com/"
                self.errorMessage = "Sua conta precisa passar por um desafio de verificação no Instagram. Volte novamente após o desafio."
                return
            }
        }
        
        self.errorMessage = "Erro: \(error.localizedDescription)"
    }
    
    
}
