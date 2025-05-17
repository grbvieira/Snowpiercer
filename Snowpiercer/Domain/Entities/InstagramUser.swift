//
//  InstagramUser.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import Foundation

// MARK: - Models

struct InstagramUser: Hashable, Codable {
    let identifier: String
    let username: String
    let fullName: String?
    let biography: String?
    let category: String?
    let profilePicURL: URL?
    let avatar: URL?
    let access: [AccessType]
    let friendship: FriendshipStatus?
    let counters: Counters?

    struct FriendshipStatus: Hashable, Codable {
        let following: Bool?
        let followedBy: Bool?
        let blocking: Bool?
        let isBestFriend: Bool?
    }

    struct Counters: Hashable, Codable {
        let posts: Int
        let followers: Int
        let following: Int
        let tags: Int
        let clips: Int
        let effects: Int
        let igtv: Int
    }

    enum AccessType: String, Codable, CaseIterable {
        case `private`
        case verified
        case business
        case creator
    }
}
