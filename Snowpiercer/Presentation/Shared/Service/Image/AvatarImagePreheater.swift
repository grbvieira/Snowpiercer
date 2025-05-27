//
//  AvatarImagePreheater.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 10/05/25.
//

import Nuke
import UIKit

final class AvatarImagePreheater {

    static let shared = AvatarImagePreheater()

    private init() {}

    func preheat(urls: [URL?]) {
        let validURLs = urls.compactMap { $0 }
        let requests = validURLs.map {
            ImageRequest(
                url: $0,
                processors: [ImageProcessors.Resize(size: CGSize(width: 120, height: 120))]
            )
        }

        Task {
            for request in requests {
                _ = try? await ImagePipeline.shared.image(for: request)
            }
        }
    }
}

