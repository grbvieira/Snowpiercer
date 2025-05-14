//
//  UserListStorage.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 13/05/25.
//

import Foundation
import UIKit

final class UserListStorage {
    static let shared = UserListStorage()
    private init() {}

    private let fileManager = FileManager.default

    private func fileURL(for type: UserSectionCard) -> URL {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("\(type.title).json")
    }

    func save(_ users: [InstagramUser], type: UserSectionCard) {
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: fileURL(for: type))
        } catch {
            print("Erro ao salvar \(type):", error)
        }
    }

    func load(type: UserSectionCard) -> [InstagramUser] {
        do {
            let data = try Data(contentsOf: fileURL(for: type))
            return try JSONDecoder().decode([InstagramUser].self, from: data)
        } catch {
            return []
        }
    }

    func clear(type: UserSectionCard) {
        try? fileManager.removeItem(at: fileURL(for: type))
    }
}
