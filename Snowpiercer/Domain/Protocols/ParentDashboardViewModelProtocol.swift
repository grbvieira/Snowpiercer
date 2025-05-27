//
//  ParentDashboardViewModelProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 24/05/25.
//

import Combine
import Foundation

@MainActor
protocol ParentDashboardViewModelProtocol {
    // MARK: - Estado da UI
    var dashboardCards: [DashboardCard] { get }
    
    // MARK: - ViewModel filhos
    var userDashboardViewModel: any UserDashboardViewModelProtocol { get }
    var userListViewModel: any UserListViewModelProtocol { get }
    
    // MARK: - Carregar dados iniciais 
    
    func loadInitialData() async
    func refreshData() async
}
