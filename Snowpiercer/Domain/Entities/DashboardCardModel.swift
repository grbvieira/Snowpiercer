//
//  DashboardCard.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 19/05/25.
//

import SwiftUI

struct DashboardWrapper: Codable {
    let dashboard: DashboarModel
    
    struct DashboarModel: Codable {
        let title: String
        let cards: [Card]
        
        struct Card: Codable, Identifiable {
            let id: String
            let title: String
            let icon: String
            let iconFontSize: CGFloat
            let titleFontSize: CGFloat
            let colors: CardColors
        }
        
        struct CardColors: Codable {
            let cardBackground: String
            let iconColor: String
            let titleColor: String
        }
        
    }
}
