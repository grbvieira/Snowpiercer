//
//  UserDashboardViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 19/05/25.
//

import SwiftUI
/// Mover para pasta de protocolo?
/// Provavelmente vai tudo pro case
protocol DashboardLoaderProtocol {
    func loadDashboard() -> [DashboardWrapper.DashboardModel.Card]
}

class JSONDashboardLoader: DashboardLoaderProtocol {
    func loadDashboard() -> [DashboardWrapper.DashboardModel.Card] {
        guard let data = ReadJson.shared.get(archive: "UserDashbiardJson") else { return [] }
        return (try? JSONDecoder().decode(DashboardWrapper.self, from: data).dashboard.cards)!
    }
}

class UserDashboardViewModel: ObservableObject {
    
    @Published var dashboardCards: [DashboardWrapper.DashboardModel.Card] = []
    private let loader: DashboardLoaderProtocol
    
    init(loader: DashboardLoaderProtocol = JSONDashboardLoader()) {
        self.loader = loader
        loadDashboard()
    }
    
    func loadDashboard() {
        dashboardCards = loader.loadDashboard()
    }
}
