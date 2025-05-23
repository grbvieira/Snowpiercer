//
//  readJson.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 19/05/25.
//

import SwiftUI

final class ReadJson {
    static let shared = ReadJson()
    
    func get(archive: String) -> Data? {
        if let url = Bundle.main.url(forResource: archive, withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                return jsonData
            } catch {
                print("Erro ao carregar JSON: \(error)")
            }
        }
        return nil
    }
}
