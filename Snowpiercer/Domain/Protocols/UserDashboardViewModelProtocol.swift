//
//  UserDashboardViewModelProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 25/05/25.
//
import Foundation

protocol UserDashboardViewModelProtocol: ObservableObject {
    var dashboardCards: [DashboardCard] { get }
    func loadDashboardData()
}
