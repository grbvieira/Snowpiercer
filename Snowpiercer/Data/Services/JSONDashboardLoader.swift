//
//  Untitled.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 24/05/25.
//

import Foundation

class JSONDashboardLoader: DashboardLoaderProtocol {
    func loadDashboard() -> [DashboardWrapper.DashboardModel.Card] {
        guard let data = ReadJson.shared.get(archive: "UserDashboardJson") else { return [] }
        return (try? JSONDecoder().decode(DashboardWrapper.self, from: data).dashboard.cards)!
    }
}
