//
//  InstagramUserDTO.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import Foundation
import Swiftagram

struct InstagramUserDTO {
    let username: String
    let fullName: String?
    let profilePicURL: URL?
    let avatar: URL?

    init(from user: Swiftagram.User) {
        self.username = user.username ?? ""
        self.fullName = user.name
        self.profilePicURL = user.thumbnail
        self.avatar = user.avatar
    }

    func toDomain() -> InstagramUser {
        return InstagramUser(
            username: username,
            fullName: fullName,
            profilePicURL: profilePicURL,
            avatar: profilePicURL
        )
    }
}
