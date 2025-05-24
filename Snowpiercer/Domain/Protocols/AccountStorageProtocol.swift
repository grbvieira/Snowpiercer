//
//  AccountStorageProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 24/05/25.
//

protocol AccountStorageProtocol {
    func save(_ user: InstagramUser, for identifier: String)
    func load(for identifier: String) -> InstagramUser?
    func delete(for identifier: String)
    func clear()
}
