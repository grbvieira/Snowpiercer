//
//  Untitled.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 14/05/25.
//
import UIKit

final class AccountStorage {
    
    static let shared = AccountStorage()
     private let key = "cachedAccounts"
    
    //MARK: - Salvar usuário localmente
    func save(_ user: InstagramUser, for identifier: String) {
        var dictionary = loadAll() ?? [:]
        let dto = InstagramUserDTO(from: user)
        dictionary[identifier] = dto
        store(dictionary)
    }
    
    //MARK: - Carregar usuário por identificador
    func load(for identifier: String) -> InstagramUser? {
        return loadAll()?[identifier]?.toDomain()
    }
    
    // MARK: - Carregar todos os usuários salvos
    private func loadAll() -> [String: InstagramUserDTO]? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: InstagramUserDTO].self, from: data)
        else { return [:] }
        return decoded
    }
    
    //MARK: - Persistir dados
    private func store(_ dict: [String: InstagramUserDTO]) {
        if let data = try? JSONEncoder().encode(dict) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    // MARK: - Remover usuário específico
    func delete(for identifier: String) {
        var dictionary = loadAll() ?? [:]
        dictionary.removeValue(forKey: identifier)
        store(dictionary)
    }

    //MARK: - Limpar Cache
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
