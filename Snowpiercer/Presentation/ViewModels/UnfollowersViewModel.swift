//
//  UnfollowersViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 04/05/25.
//

import UIKit
import Swiftagram

@MainActor
final class UnfollowersViewModel: ObservableObject {
    @Published var nonFollowers: [InstagramUser] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    let useCase: FetchNonFollowersUseCaseProtocol

    init(useCase: FetchNonFollowersUseCaseProtocol) {
        self.useCase = useCase
    }

    func fetchNonFollowers(secret: Secret) async {
        isLoading = true
        do {
            let result = try await useCase.execute(secret: secret)
            nonFollowers = result
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
