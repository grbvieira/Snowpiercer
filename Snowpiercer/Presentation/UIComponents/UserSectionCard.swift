//
//  UserSectionCard.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//
import UIKit

enum UserSectionCard: CaseIterable {
    case followers, following, unfollowers

    var title: String {
        switch self {
        case .followers: return "Seguidores"
        case .following: return "Seguindo"
        case .unfollowers: return "Não Seguem"
        }
    }

    var icon: String {
        switch self {
        case .followers: return "person.2.fill"
        case .following: return "arrow.right"
        case .unfollowers: return "person.crop.circle.badge.xmark"
        }
    }
}
