//
//  HasLoadingStateProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 27/05/25.
//

@MainActor
protocol HasLoadingStateProtocol {
    var isLoading: Bool { get }
    var loadProgress: Double { get }
}
