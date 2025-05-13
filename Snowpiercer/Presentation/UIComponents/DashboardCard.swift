//
//  DashboardCard.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct DashboardCard: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.orange)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
