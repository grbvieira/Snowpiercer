//
//  AvatarViewModel.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import SwiftUI

@MainActor
final class AvatarViewModel: ObservableObject {
    @Published var image: UIImage?
    
    private let url: URL?
    private let size: CGSize
    private let loader: ImageLoader

    init(url: URL?, size: CGSize, loader: ImageLoader = NukeImageLoader()) {
        self.url = url
        self.size = size
        self.loader = loader
    }

    func load() async {
        guard let url else {
            image = UIImage(named: "generic_user")
            return
        }
        
        do {
            let img = try await loader.loadImage(from: url, size: size)
            withAnimation(.easeIn(duration: 0.25)) {
                self.image = img
            }
        } catch {
            print("❌ Falha ao carregar imagem: \(error)")
        }
    }
}

