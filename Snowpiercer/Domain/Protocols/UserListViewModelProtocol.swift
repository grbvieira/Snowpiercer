//
//  UserListViewModelProtocol.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 25/05/25.
//

import Foundation
import Swiftagram

protocol UserListViewModelProtocol: ObservableObject {
    
    var followers: [InstagramUser] { get }
    var following: [InstagramUser] { get }
    var nonFollowers: [InstagramUser] { get }
    
    var searchText: String { get set }
    var currentListType: UserSectionCard { get set }
    var filteredUsers: [InstagramUser] { get }
    var hasLoadedInitialData: Bool { get }
    
    func loadUserList(forceReload: Bool) async
    func setup(with secret: Secret)
    
    func loadCachedLists()
}
