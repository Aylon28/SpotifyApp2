//
//  ProfileViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 12.04.23.
//

import UIKit

class ProfileViewController: UIViewController {
    var viewModel = ProfileViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UserProfileTableViewCell.self, forCellReuseIdentifier: UserProfileTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindings()
        viewModel.fetchUserData() { [weak self] result in
            DispatchQueue.main.async {
                if result {
                    self?.createTableHeader(imageURLString: self?.viewModel.userInfoResponse?.images.first?.url)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setupBindings() {
        viewModel.userInfo.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createTableHeader(imageURLString: String?) {
        guard let imageURLString, let imageURL = URL(string: imageURLString) else { return }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        let imageSize = headerView.height/1.5
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: imageURL)
        imageView.layer.cornerRadius = imageSize/2
        imageView.layer.masksToBounds = true
        tableView.tableHeaderView = headerView
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserProfileTableViewCell.identifier, for: indexPath) as? UserProfileTableViewCell else { return UITableViewCell() }
        let cellViewModel = viewModel.getUserProfileTableViewCellViewModel(indexPath.row)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemsCount
    }
}
