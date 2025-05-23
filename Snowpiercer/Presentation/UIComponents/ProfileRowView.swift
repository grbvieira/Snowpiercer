//
//  ProfileViewCell.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import SwiftUI

struct ProfileRowView: View {
    enum Display {
        case home
        case list
    }
    
    let user: InstagramUser
    let display: Display
    
    var body: some View {
        HStack(spacing: 8) {
            AvatarView(size: .mid,
                       user: user)
            
            VStack(alignment: .leading, spacing: 2) {
                
                HStack(spacing: 4) {
                    if let name = user.fullName {
                        Text(name)
                            .font(.body)
                            .foregroundStyle(Color.snowpiercerTextPrimary)
                    }
                    if display == .list {
                        if user.access.contains(.private) {
                            Image(systemName: "lock")
                        } else {
                            Image(systemName: "lock.open")
                        }
                    }
                }
                
                Text("@\(user.username)")
                    .font(.caption)
                    .foregroundStyle(Color.snowpiercerSecondaryText)
                
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(UIColor.systemGray6).opacity(0.2))
        .cornerRadius(12)
    }
}
