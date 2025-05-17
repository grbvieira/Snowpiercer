//
//  InstagramUser+Mock.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 17/05/25.
//
import SwiftUI

extension InstagramUser {
    static var mock: InstagramUser {
        InstagramUser(
            identifier: "1234567890",
            username: "mockuser",
            fullName: "Mock User",
            biography: "Essa é uma bio de exemplo.",
            category: "Criador de Conteúdo",
            profilePicURL: URL(string: "https://example.com/pic.jpg"),
            avatar: URL(string: "https://example.com/avatar.jpg"),
            access: [.private, .verified],
            friendship: FriendshipStatus(
                following: true,
                followedBy: true,
                blocking: false,
                isBestFriend: true
            ),
            counters: Counters(
                posts: 42,
                followers: 1234,
                following: 567,
                tags: 10,
                clips: 3,
                effects: 1,
                igtv: 0
            )
        )
    }
}
