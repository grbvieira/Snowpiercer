//
//  Color+Extension.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 19/05/25.
//
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

extension Color {
    static let snowpiercerBackground = Color(hex: "#1e1e1e")
    static let snowpiercerCard = Color(hex: "#101010")
    static let snowpiercerSecondaryText = Color(hex: "#2e2e2e")
    static let snowpiercerTextPrimary = Color.white
}
