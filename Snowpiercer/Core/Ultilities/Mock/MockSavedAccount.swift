//
//  MockSavedAccount.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import Swiftagram

struct MockSavedAccount {
    static var preview: SavedAccount {
        let user = InstagramUser(
            username: "gersonvieira",
            fullName: "Gerson Vieira",
            profilePicURL: nil,
            avatar: nil
        )

        struct FakeSecret: Equatable {
            let identifier = "123"
        }

        let fakeSecret = unsafeBitCast(FakeSecret(), to: Secret.self)
        
        return SavedAccount(secret: fakeSecret, user: user)
    }
}
