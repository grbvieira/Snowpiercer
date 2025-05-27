//
//  UserListViewModelProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 25/05/25.
//

import Foundation
import Swiftagram

@MainActor
protocol UserListViewModelProtocol: ObservableObject {
    
    var followers: [InstagramUser] { get }
    var following: [InstagramUser] { get }
    var nonFollowers: [InstagramUser] { get }
    var filteredUsers: [InstagramUser] { get }
    var searchText: String { get set }
    var currentListType: UserSectionCard { get set }
    var hasLoadedInitialData: Bool { get }
    var isDataLoaded: Bool { get }

    func setup()
    func loadUserList(forceReload: Bool) async
}
