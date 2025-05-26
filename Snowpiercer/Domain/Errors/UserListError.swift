//
//  UserListError.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 25/05/25.
//
 import Foundation

enum UserListError: LocalizedError {
    case missingSecret
    case apiError(Error)
    case unknowm
    
    var errorDescription: String? {
        switch self {
        case .missingSecret:
            return "Erro Interno: Segredo do usuário não configurado."
        case .apiError(let error):
            return "Erro ao buscar dados: \(error.localizedDescription)"
        case .unknowm:
            return "Ocorreu um erro desconhecido."
        }
    }
}
