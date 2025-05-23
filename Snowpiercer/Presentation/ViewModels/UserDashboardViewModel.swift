//
//  UserDashboardViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 19/05/25.
//

import SwiftUI

class UserDashboardViewModel: ObservableObject {
    
    @Published var dashboardCards: [DashboardWrapper.DashboarModel.Card] = []
    
    init() {
        loadDashboard()
        print("Carregou")
    }
    
    func loadDashboard() {
         guard let data = ReadJson.shared.get(archive: "UserDashboardJson") else {
             print("Erro ao buscar json")
             return
         }

         do {
             let result = try JSONDecoder().decode(DashboardWrapper.self, from: data)
             self.dashboardCards = result.dashboard.cards
         } catch {
             print("Erro ao obter o Dashboard: \(error)")
         }
     }
}
