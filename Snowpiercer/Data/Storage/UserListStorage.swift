//
//  UserListStorage.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 13/05/25.
//

import Foundation

final class UserListStorage: UserListStorageProtocol {
    
    private let fileManager = FileManager.default

    private func fileURL(for type: UserSectionCard, userID: String) -> URL {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent("\(userID)_\(type.title).json")
    }

    func save(_ users: [InstagramUser], type: UserSectionCard, userID: String) {
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: fileURL(for: type, userID: userID))
        } catch {
            print("Erro ao salvar \(type):", error)
        }
    }

    func load(type: UserSectionCard, userID: String) -> [InstagramUser] {
        do {
            let data = try Data(contentsOf: fileURL(for: type, userID: userID ))
            return try JSONDecoder().decode([InstagramUser].self, from: data)
        } catch {
            return []
        }
    }

    private func clear(type: UserSectionCard, userID: String) {
        try? fileManager.removeItem(at: fileURL(for: type, userID: userID))
        
    }
    
    func clearAll(for userID: String) {
        UserSectionCard.allCases.forEach { type in
            clear(type: type, userID: userID)
        }
    }
}
