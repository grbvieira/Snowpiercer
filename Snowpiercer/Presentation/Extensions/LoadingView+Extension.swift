//
//  LoadingView+Extension.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 27/05/25.
//

import SwiftUI

private struct LoadingOverlayModifier<T: ObservableObject>: ViewModifier {
    @ObservedObject var viewModel: T
    let isLoadingKeyPath: KeyPath<T, Bool>
    let progressKeyPath: KeyPath<T, Double>

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(viewModel[keyPath: isLoadingKeyPath])
                .blur(radius: viewModel[keyPath: isLoadingKeyPath] ? 3 : 0)

            if viewModel[keyPath: isLoadingKeyPath] {
                VStack(spacing: 12) {
                    ProgressView(value: viewModel[keyPath: progressKeyPath])
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.horizontal)
                    Text("Carregando... \(Int(viewModel[keyPath: progressKeyPath] * 100))%")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(radius: 8)
            }
        }
    }
}

extension View {
    func loadingProgressOverlay<T: ObservableObject>(
        viewModel: T
    ) -> some View where T: HasLoadingStateProtocol {
        modifier(
            LoadingOverlayModifier(
                viewModel: viewModel,
                isLoadingKeyPath: \.isLoading,
                progressKeyPath: \.loadProgress
            )
        )
    }
}



