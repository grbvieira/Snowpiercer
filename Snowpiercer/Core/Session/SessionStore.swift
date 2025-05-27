//
//  SessionStore.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 27/05/25.
//

import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published var currentAccount: SavedAccount?
}
