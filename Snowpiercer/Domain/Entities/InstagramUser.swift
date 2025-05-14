//
//  InstagramUser.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//
import UIKit

// MARK: - Models
struct InstagramUser: Hashable, Codable {
    let username: String
    let fullName: String?
    let profilePicURL: URL?
    let avatar: URL?
}
