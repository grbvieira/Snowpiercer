//
//  SavedAccount.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 10/05/25.
//
import UIKit
import Swiftagram

struct SavedAccount: Identifiable {
    var id: String { secret.identifier }
    let secret: Secret
    let user: InstagramUser
}
