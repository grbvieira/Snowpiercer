//
//  ShimmerViewCell.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 06/05/25.
//

import UIKit

final class ShimmerTableViewCell: UITableViewCell {

    private let shimmerView = ShimmerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupShimmer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShimmer()
    }

    private func setupShimmer() {
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shimmerView)

        NSLayoutConstraint.activate([
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shimmerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
