//
//  ExpandableCell.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 17/05/25.
//

import SwiftUI

struct ExpandableUserCell: View {
    let user: InstagramUser
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AsyncImage(url: user.avatar) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 44, height: 44)
                }

                Text(user.username)
                    .font(.headline)

                Spacer()

                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.25), value: isExpanded)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    if let name = user.fullName {
                        Text("Nome completo: \(name)")
                            .font(.subheadline)
                    }

                    if let bio = user.biography {
                        Text("Bio: \(bio)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    if let c = user.counters {
                        HStack(spacing: 16) {
                            Label("\(c.followers) seguidores", systemImage: "person.2")
                            Label("\(c.following) seguindo", systemImage: "person")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Divider()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .animation(.easeInOut(duration: 0.25), value: isExpanded)
    }
}
/*
struct ExpandableCell: View {
    let title: String
    let description: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)

                Spacer()

                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.25), value: isExpanded)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .transition(.opacity)
            }

            Divider()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}
*/
