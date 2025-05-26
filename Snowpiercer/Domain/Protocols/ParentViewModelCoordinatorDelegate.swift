//
//  ParentViewModelCoordinatorDelegate.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 26/05/25.
//

import Foundation

@MainActor
protocol ParentViewModelCoordinatorDelegate: AnyObject {
    func updateProgress(_ progress: Double)
    func handleError(_ error: Error)
}
