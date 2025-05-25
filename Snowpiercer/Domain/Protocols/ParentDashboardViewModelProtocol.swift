//
//  ParentDashboardViewModelProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 24/05/25.
//

import Combine
import Foundation

protocol ParentDashboardViewModelProtocol: ErrorHandlingProtocol {
    // MARK: - Estado da UI
    var isLoading: Bool { get set }
    var loadProgress: Double { get set }
    
    // MARK: - ViewModel filhos
    var userDashboardViewModel: UserDashboardViewModelProtocol { get }
    var userListViewModel: UserListViewModelProtocol { get }
    
    // MARK: - Carregar dados iniciais 
    
    func loadInitialData(account: SavedAccount) async
    func refreshData() async
}
