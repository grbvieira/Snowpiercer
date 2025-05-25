//
//  DashboardCard.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 19/05/25.
//

import Foundation

struct DashboardWrapper: Codable {
    let dashboard: DashboardModel
    
}

struct DashboardModel: Codable {
    let title: String
    let cards: [DashboardCard]
}


struct DashboardCard: Codable, Identifiable {
    let id: String
    let title: String
    let icon: String
    let iconFontSize: CGFloat
    let titleFontSize: CGFloat
    let colors: DashboardCardColors
}

struct DashboardCardColors: Codable {
    let cardBackground: String
    let iconColor: String
    let titleColor: String
}
