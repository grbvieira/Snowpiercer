//
//  ImageLoader.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 12/05/25.
//

import UIKit

protocol ImageLoader {
    func loadImage(from url: URL, size: CGSize) async throws -> UIImage
}

