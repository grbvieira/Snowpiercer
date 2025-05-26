//
//  ParentDashboardViewModelProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 24/05/25.
//

import Combine
import Foundation

@MainActor
protocol ParentDashboardViewModelProtocol: ErrorHandlingProtocol {
    // MARK: - Estado da UI
    var isLoading: Bool { get set }
    var loadProgress: Double { get set }
    
    // MARK: - ViewModel filhos
    var userDashboardViewModel: any UserDashboardViewModelProtocol { get }
    var userListViewModel: any UserListViewModelProtocol { get }
    
    // MARK: - Carregar dados iniciais 
    
    func loadInitialData(account: SavedAccount) async
    func refreshData() async
}

protocol ParentViewModelCoordinatorDelegate: AnyObject {
    func updateProgress(_ progress: Double)
    func handleError(_ error: Error)
}
