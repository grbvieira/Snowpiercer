//
//  InstagramServiceProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import UIKit

protocol InstagramServiceProtocol {
    func login(viewController: UIViewController)async throws -> Secret
    func fetchFollowing(secret: Secret) async throws -> [InstagramUser]
    func fetchFollowers(secret: Secret) async throws -> [InstagramUser]
}
