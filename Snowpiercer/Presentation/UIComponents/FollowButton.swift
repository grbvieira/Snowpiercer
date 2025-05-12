//
//  FollowButton.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

struct FollowButton: View {
    var action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 2) {
            Button(action: action) {
                Text("Unfollow")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .opacity(isPressed ? 0.8 : 1.0)
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.easeIn(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.easeOut(duration: 0.1)) {
                            isPressed = false
                        }
                    }
            )
            
            Button(action: action) {
                Text("Unfollow")
                    .font(.subheadline.bold())
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .clipShape(Capsule())
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .opacity(isPressed ? 0.8 : 1.0)
            }

        }
    }
}
