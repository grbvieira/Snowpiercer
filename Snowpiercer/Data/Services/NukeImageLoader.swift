//
//  NukeImageLoader.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//
import Nuke
import UIKit

final class NukeImageLoader: ImageLoader {

    private static let cache = NSCache<NSURL, UIImage>()

    func loadImage(from url: URL, size: CGSize) async throws -> UIImage {
        if let cached = Self.cache.object(forKey: url as NSURL) {
            return cached
        }

        let request = ImageRequest(
            url: url,
            processors: [ImageProcessors.Resize(size: size)]
        )

        let image = try await ImagePipeline.shared.image(for: request)

        Self.cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
