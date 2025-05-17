//
//  InstagramUserDTO.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import Foundation
import Swiftagram

//
//  InstagramUserDTO.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import Foundation
import Swiftagram

struct InstagramUserDTO: Codable {
    let identifier: String
    let username: String
    let fullName: String?
    let biography: String?
    let category: String?
    let profilePicURL: URL?
    let avatar: URL?
    let access: [InstagramUser.AccessType]
    let friendship: InstagramUser.FriendshipStatus?
    let counters: InstagramUser.Counters?

    init(from user: Swiftagram.User) {
        self.identifier = user.identifier ?? ""
        self.username = user.username ?? ""
        self.fullName = user.name
        self.biography = user.biography
        self.category = user.category
        self.profilePicURL = user.thumbnail
        self.avatar = user.avatar

        self.access = {
            guard let access = user.access else { return [] }
            var result: [InstagramUser.AccessType] = []
            if access.contains(.private) { result.append(.private) }
            if access.contains(.verified) { result.append(.verified) }
            if access.contains(.business) { result.append(.business) }
            if access.contains(.creator) { result.append(.creator) }
            return result
        }()

        self.friendship = {
            guard let f = user.friendship else { return nil }
            return InstagramUser.FriendshipStatus(
                following: f["following"].bool(),
                followedBy: f["followedBy"].bool(),
                blocking: f["blocking"].bool(),
                isBestFriend: f["isBestie"].bool()
            )
        }()

        self.counters = {
            guard let c = user.counter else { return nil }
            return InstagramUser.Counters(
                posts: c.posts,
                followers: c.followers,
                following: c.following,
                tags: c.tags,
                clips: c.clips,
                effects: c.effects,
                igtv: c.igtv
            )
        }()
    }

    func toDomain() -> InstagramUser {
        .init(
            identifier: identifier,
            username: username,
            fullName: fullName,
            biography: biography,
            category: category,
            profilePicURL: profilePicURL,
            avatar: avatar,
            access: access,
            friendship: friendship,
            counters: counters
        )
    }
    
    init(from domain: InstagramUser) {
        self.identifier = domain.identifier
        self.username = domain.username
        self.fullName = domain.fullName
        self.biography = domain.biography
        self.category = domain.category
        self.profilePicURL = domain.profilePicURL
        self.avatar = domain.avatar
        self.access = domain.access
        self.friendship = domain.friendship
        self.counters = domain.counters
    }
}


/*
 init(from domain: InstagramUser) {
      self.username = domain.username
      self.fullName = domain.fullName
      self.profilePicURL = domain.profilePicURL
      self.avatar = domain.avatar
  }
 */
 
