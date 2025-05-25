//
//  ErrorHandlingViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 25/05/25.
//
import Foundation

protocol ErrorHandlingProtocol: ObservableObject {
    var errorMessage: String? { get set }
    var challengeURL: String? { get }
}
