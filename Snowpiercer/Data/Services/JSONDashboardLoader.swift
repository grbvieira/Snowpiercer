//
//  Untitled.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 24/05/25.
//

import Foundation

class JSONDashboardLoader: DashboardLoaderProtocol {
    func loadDashboard() -> [DashboardCard] {
        guard let data = ReadJson.shared.get(archive: "UserDashboardJson") else { return [] }
        do {
            let wrapper = try JSONDecoder().decode(DashboardWrapper.self, from: data)
            return wrapper.dashboard.cards
        } catch {
            return []
        }
    }
}
