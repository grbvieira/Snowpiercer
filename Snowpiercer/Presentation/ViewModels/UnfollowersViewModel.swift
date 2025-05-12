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
    
    @Published private(set) var nonFollowers: [InstagramUser] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let useCase: FetchNonFollowersUseCase
    
    init(useCase: FetchNonFollowersUseCase) {
        self.useCase = useCase
    }
    
    func fetchNonFollowers(secret: Secret) {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                nonFollowers = try await useCase.execute(secret: secret)
            } catch {
                errorMessage = "Failed to fetch users: \(error.localizedDescription)"
                nonFollowers = []
            }
        }
    }
}
