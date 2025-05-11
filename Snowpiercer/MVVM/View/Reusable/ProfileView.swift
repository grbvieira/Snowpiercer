//
//  ProfileView.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 06/05/25.
//

import UIKit

final class ProfileView: UIView {

    private let avatar: AvatarView
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()

    private let savedAccount: SavedAccount

    init(user: SavedAccount) {
        self.savedAccount = user
        self.avatar = AvatarView(url: user.user.avatar)
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        nameLabel.text = savedAccount.user.fullName
        usernameLabel.text = "@\(savedAccount.user.username)"

        let labelsStack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 4

        let containerStack = UIStackView(arrangedSubviews: [avatar, labelsStack])
        containerStack.axis = .horizontal
        containerStack.spacing = 12
        containerStack.alignment = .center
        containerStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(containerStack)

        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.heightAnchor.constraint(equalToConstant: 60),
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
