//
//  MockSavedAccount.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import Swiftagram
import UIKit
/// Acho que isso não é mais necessario
/*struct MockSavedAccount {
    static var preview: SavedAccount {
        let user = InstagramUser(
            username: "mockuser",
            fullName: "Mock User",
            profilePicURL: nil,
            avatar: nil
        )

        let cookieProps: [HTTPCookiePropertyKey: Any] = [
            .domain: "instagram.com",
            .path: "/",
            .name: "sessionid",
            .value: "mock_session_id",
            .secure: true,
            .expires: Date().addingTimeInterval(60 * 60 * 24 * 365)
        ]

        guard let cookie = HTTPCookie(properties: cookieProps) else {
            print("❌ ERRO: não conseguiu criar cookie")
            return SavedAccount(secret: Secret(cookies: [])!, user: user)
        }

        guard let secret = Secret(cookies: [cookie]) else {
            print("❌ ERRO: não conseguiu criar Secret")
            return SavedAccount(secret: Secret(cookies: [])!, user: user)
        }

        return SavedAccount(secret: secret, user: user)
    }
}
*/
