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
    
    init(userDashboardViewModel: any UserDashboardViewModelProtocol, userListViewModel: any UserListViewModelProtocol) {
        self.userDashboardViewModel = userDashboardViewModel
        self.userListViewModel = userListViewModel
    }
    
    // MARK: - Load Initial Data
    func loadInitialData() async {
        userListViewModel.setup()
        guard !userListViewModel.isDataLoaded else {
            return
        }
        await userListViewModel.loadUserList(forceReload: false)
    }

    
    // MARK: Update Data
    func refreshData() async {
        await userListViewModel.loadUserList(forceReload: true)
    }
}
