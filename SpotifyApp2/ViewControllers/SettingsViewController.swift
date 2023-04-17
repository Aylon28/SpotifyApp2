//
//  SettingsViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 12.04.23.
//

import UIKit

class SettingsViewController: UIViewController {
    var viewModel = SettingsViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadSettings()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func loadSettings() {
        viewModel.settings.value.append(Section(title: "Profile", options: [
            Option(title: "View your profile", iconSystemName: "person", handler: { [weak self] in
                let vc = ProfileViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
        ]))
        viewModel.settings.value.append(Section(title: "Actions", options: [
            Option(title: "Sign Out", iconSystemName: "rectangle.portrait.and.arrow.forward", handler: { [weak self] in
                self?.viewModel.signOut() { result in
                    DispatchQueue.main.async {
                        if result {
                            let navVc = UINavigationController(rootViewController: SignInViewController())
                            navVc.modalPresentationStyle = .fullScreen
                            self?.present(navVc, animated: true) {
                                self?.navigationController?.popToRootViewController(animated: false)
                            }
                        }
                    }
                }
            })
        ]))
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settingsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSettingsInSectionCount(section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitleForHeader(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.identifier, for: indexPath) as? DefaultTableViewCell else { return UITableViewCell() }
        let cellViewModel = viewModel.getDefaultTableViewSystemImageCellViewModel(indexPath)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.settingTapped(indexPath)
    }
}
