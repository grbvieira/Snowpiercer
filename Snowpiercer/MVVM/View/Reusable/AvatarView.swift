//
//  AvatarView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 10/05/25.
//

import UIKit
import Nuke

final class AvatarView: UIView {

    // MARK: - Cache (manual)
    private static let imageCache = NSCache<NSURL, UIImage>()

    // MARK: - UI Components
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let initialsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let size: CGFloat
    private let imageURL: URL?
    private lazy var fallbackInitial: String = {
        fallbackName?.first.map { String($0).uppercased() } ?? "?"
    }()

    private let fallbackName: String?

    // MARK: - Init
    init(url: URL?, fallbackName: String? = nil, size: CGFloat = 60) {
        self.imageURL = url
        self.fallbackName = fallbackName
        self.size = size
        super.init(frame: .zero)
        setupUI()
        loadImage()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        layer.cornerRadius = size / 2
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        initialsLabel.font = UIFont.systemFont(ofSize: size / 2, weight: .medium)

        addSubview(imageView)
        addSubview(initialsLabel)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size),

            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            initialsLabel.topAnchor.constraint(equalTo: topAnchor),
            initialsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            initialsLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            initialsLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Load Image
    private func loadImage() {
        guard let url = imageURL else {
            showFallbackInitial()
            return
        }

        if let cached = AvatarView.imageCache.object(forKey: url as NSURL) {
            imageView.image = cached
            initialsLabel.isHidden = true
            return
        }

        let request = ImageRequest(
            url: url,
            processors: [ImageProcessors.Resize(size: CGSize(width: size * 2, height: size * 2))],
            priority: .high
        )

        Task {
            do {
                let image = try await ImagePipeline.shared.image(for: request)
                AvatarView.imageCache.setObject(image, forKey: url as NSURL)
                imageView.alpha = 0
                imageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                imageView.image = image
                initialsLabel.isHidden = true

                UIView.animate(withDuration: 0.25) {
                    self.imageView.alpha = 1
                    self.imageView.transform = .identity
                }
            } catch {
                showFallbackInitial()
            }
        }
    }

    // MARK: - Fallback (Initial)
    private func showFallbackInitial() {
        imageView.image = nil
        initialsLabel.isHidden = false
        initialsLabel.text = fallbackInitial
    }
}
