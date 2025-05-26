//
//  ParentDashboardViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 23/05/25.
//

import SwiftUI
import Swiftagram

@MainActor
class ParentDashboardViewModel: ObservableObject, @preconcurrency ErrorHandlingViewModel, ParentDashboardViewModelProtocol {
    
    private let dashboardVM: UserDashboardViewModel
    private let userListVM: UserListViewModel
    
    @Published var errorMessage: String?
    @Published var challengeURL: String?
    @Published var isLoading = false
    @Published var loadProgress: Double = 0.0
    
    init(viewModelDashboard: UserDashboardViewModel, viewModelUserList: UserListViewModel ) {
        self.dashboardVM = viewModelDashboard
        self.userListVM = viewModelUserList
    }
    
    func loadInitialData(account: SavedAccount) async {
        isLoading = true
        loadProgress = 0
        defer {
            isLoading = false
            loadProgress = 1
        }
        
        do {
            async let dashboardTask: () = dashboardVM.loadDashboard()
            async let listTask: () = userListVM.loadAllData()
            
            _ = await(dashboardTask, listTask)
        } catch {
            handleError(error)
        }
    }
    
    func refreshData() async {
        await userListVM.loadAllData(forceReload: true)
    }
    
    //MARK: - Tratamento de erro genérico
    private func handleError(_ error: Error) {
        if let specializedError = error as? SpecializedError,
           case let .generic(code, response) = specializedError,
           code == "challenge_required" {
            
            let challengeWrapper = response["challenge"]
            if challengeWrapper.dictionary() != nil {
                self.challengeURL = "https://instagram.com/"
                self.errorMessage = "Sua conta precisa passar por um desafio de verificação no Instagram. Volte novamente após o desafio"
            }
        } else {
            self.errorMessage = "Erro: \(error.localizedDescription)"
        }
    }

}
