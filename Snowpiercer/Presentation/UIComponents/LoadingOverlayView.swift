//
//  LoadingOverlayView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 15/05/25.
//

import SwiftUI

struct LoadingOverlayView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 12) {
                ProgressView(value: progress)
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)

                Text("Carregando... \(Int(progress * 100))%")
                    .foregroundColor(.white)
                    .font(.footnote)
                    .bold()
            }
            .padding(20)
            .background(Color(.systemGray).opacity(0.8))
            .cornerRadius(12)
        }
    }
}
