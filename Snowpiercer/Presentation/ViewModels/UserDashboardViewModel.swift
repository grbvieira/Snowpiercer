//
//  UserDashboardViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 19/05/25.
//

import SwiftUI

@MainActor
class UserDashboardViewModel: ObservableObject, @preconcurrency UserDashboardViewModelProtocol {
  
    @Published var dashboardCards: [DashboardCard] = []
    private let loader: DashboardLoaderProtocol
    
    init(loader: DashboardLoaderProtocol = JSONDashboardLoader()) {
        self.loader = loader
        loadDashboardData()
    }
    
    func loadDashboardData() {
        dashboardCards = loader.loadDashboard()
    }
}
