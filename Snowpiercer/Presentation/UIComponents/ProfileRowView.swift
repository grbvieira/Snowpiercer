//
//  ProfileViewCell.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 11/05/25.
//

import SwiftUI

struct ProfileRowView: View {
    let user: InstagramUser
    
    var body: some View {
        HStack(spacing: 4) {
            AvatarView(size: .mid,
                       user: user)
            
            VStack(alignment: .leading, spacing: 4) {
                if let name = user.fullName {
                    Text(name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                }
                Text("@\(user.username)")
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
