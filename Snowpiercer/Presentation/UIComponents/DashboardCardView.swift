//
//  DashboardCard.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct DashboardCardView: View {
    let card:  DashboardCard
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
                Image(systemName: card.icon)
                    .font(.system(size: card.iconFontSize))
                    .foregroundColor(Color(hex: card.colors.iconColor))
            
            Text(card.title)
                .font(.system(size: card.titleFontSize))
                .foregroundColor(Color(hex: card.colors.titleColor))
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color(hex: card.colors.cardBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
