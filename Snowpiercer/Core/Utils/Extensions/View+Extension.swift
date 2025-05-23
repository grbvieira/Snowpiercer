//
//  View+Extension.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 23/05/25.
//

import SwiftUI

protocol ErrorHandlingViewModel: ObservableObject {
    var errorMessage: String? { get set }
    var challengeURL: String? { get }
}

extension View {
    func errorHandling<T: ErrorHandlingViewModel>(viewModel: T) -> some View {
        self.modifier(ErrorAlertModifier(viewModel: viewModel))
    }
}

private struct ErrorAlertModifier<T: ErrorHandlingViewModel>: ViewModifier {
    @ObservedObject var viewModel: T
    
    func body(content: Content) -> some View {
        content
            .alert("Erro", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                if let url = viewModel.challengeURL.flatMap(URL.init) {
                    Button("Abrir Instagram") {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Fechar", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Erro desconhecido")
            }
    }
}
