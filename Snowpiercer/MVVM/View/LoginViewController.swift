//
//  LoginViewController.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 29/04/25.
//

import UIKit
import Combine
import Swiftagram

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved Accounts"
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
        loadAccounts()
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(headerLabel)
        view.addSubview(mainStack)
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }
    
    private func bindViewModel() {
           viewModel.$savedSecrets
               .receive(on: DispatchQueue.main)
               .sink { [weak self] secrets in
                   self?.updateAccounts(secrets: secrets)
               }
               .store(in: &subscriptions)
           viewModel.$errorMessage
               .compactMap { $0 }
               .receive(on: DispatchQueue.main)
               .sink { [weak self] errorMessage in
                   self?.showAlert(message: errorMessage)
               }
               .store(in: &subscriptions)
           // Optional: show loading indicator with viewModel.$isLoading
       }
    
       private func loadAccounts() {
           viewModel.loadSavedAccounts()
       }
    
    private func updateAccounts(secrets: [Secret]) {
          mainStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
          guard !secrets.isEmpty else {
              headerLabel.text = "No saved accounts. Add one?"
              return
          }
          headerLabel.text = "Saved Accounts"
          for secret in secrets {
              let button = UIButton(type: .system)
              button.setTitle("Login as \(secret.identifier)", for: .normal)
              button.titleLabel?.font = .systemFont(ofSize: 18)
              button.contentHorizontalAlignment = .left
             // button.tag = secrets.firstIndex(of: secret) ?? 0
              button.addTarget(self, action: #selector(handleAccountTap(_:)), for: .touchUpInside)
              mainStack.addArrangedSubview(button)
          }
      }
    
    @objc private func didTapLogin() {
        Task {
            await viewModel.login(from: self)
        }
    }
    
    @objc private func handleAccountTap(_ sender: UIButton) {
        guard sender.tag < viewModel.savedSecrets.count else { return }
        let selectedSecret = viewModel.savedSecrets[sender.tag]
        openNonFollowers(secret: selectedSecret)
    }
    
    private func openNonFollowers(secret: Secret) {
        let unfollowersVM = UnfollowersViewModel(service: viewModel.service)
        let nonFollowersVC = NonFollowersViewController(secret: secret, viewModel: unfollowersVM)
        navigationController?.pushViewController(nonFollowersVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .cancel))
        present(alert, animated: true)
    }
    
}
