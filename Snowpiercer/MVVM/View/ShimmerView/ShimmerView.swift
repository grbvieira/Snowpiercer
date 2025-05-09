//
//  ShimmerView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 06/05/25.
//

import UIKit

final class ShimmerView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        startAnimating()
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemGray5
        layer.cornerRadius = 8
        clipsToBounds = true

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.4).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard bounds.width > 0 else { return }

        gradientLayer.frame = bounds.insetBy(dx: -bounds.width, dy: 0)

        if gradientLayer.animation(forKey: "shimmer") == nil {
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.fromValue = -bounds.width
            animation.toValue = bounds.width
            animation.duration = 1.2
            animation.repeatCount = .infinity
            gradientLayer.add(animation, forKey: "shimmer")
        }
    }


    private func startAnimating() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }
}
