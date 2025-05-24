//
//  UserListStorage.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 24/05/25.
//

protocol UserListStorageProtocol {
    func save(_ users: [InstagramUser], type: UserSectionCard, userID: String)
    func load(type: UserSectionCard, userID: String) -> [InstagramUser]
    func clearAll(for userID: String)
}
