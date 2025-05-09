//
//  NonFollowersViewController.swift
//  Snowpiercer
//
//  Created by Gerson Vieira on 29/04/25.
//

import UIKit
import Swiftagram

final class NonFollowersViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: UnfollowersViewModel
    private let secret: Secret
    private var subscriptions = Set<AnyCancellable>()
    init(secret: Secret, viewModel: UnfollowersViewModel) {
        self.secret = secret
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Quem não te segue"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        fetchData()
    }
    
    private func setupView() {
           view.backgroundColor = .systemBackground
           tableView.dataSource = self
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
           tableView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(tableView)
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
           ])
       }

    private func bindViewModel() {
           viewModel.$nonFollowers
               .receive(on: DispatchQueue.main)
               .sink { [weak self] _ in
                   self?.tableView.reloadData()
               }
               .store(in: &subscriptions)
           viewModel.$errorMessage
               .compactMap { $0 }
               .receive(on: DispatchQueue.main)
               .sink { [weak self] message in
                   self?.presentAlert(message: message)
               }
               .store(in: &subscriptions)
           // Optional: bind isLoading for loading UI
       }
    
       private func fetchData() {
           Task {
               await viewModel.fetchNonFollowers(secret: secret)
           }
       }
    
    private func presentAlert(message: String) {
        let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .cancel))
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension NonFollowersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.nonFollowers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = viewModel.nonFollowers[indexPath.row]
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.fullName ?? ""
        cell.imageView?.image = UIImage(systemName: "person.circle")
        cell.imageView?.layer.cornerRadius = 20
        cell.imageView?.clipsToBounds = true
        
        if let url = user.profilePicURL {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    guard let updateCell = tableView.cellForRow(at: indexPath) else { return }
                    updateCell.imageView?.image = image
                    updateCell.setNeedsLayout()
                }
            }.resume()
        }
        return cell
    }
}
