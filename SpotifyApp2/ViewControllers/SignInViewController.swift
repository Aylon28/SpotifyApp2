//
//  SignInViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 6.04.23.
//

import UIKit

class SignInViewController: UIViewController {
    var viewModel = SignInViewModel()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Spotify"
        label.font = .systemFont(ofSize: 50, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sing In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if viewModel.isSignedIn {
            showTabBarView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAnchors()
    }
    
    private func showTabBarView() {
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func setupUI() {
        view.backgroundColor = .systemGreen
        view.addSubview(appNameLabel)
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
    }
    
    @objc private func didTapSignInButton() {
        showAuthView()
    }
    
    private func showAuthView() {
        let vc = AuthenticationViewController()
        vc.viewModel.completionHandler = { [weak self] result in
            DispatchQueue.main.async {
                self?.handleSignIn(result)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(_ result: Bool) {
        if result {
            let vc = TabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        } else {
            let alertController = UIAlertController(title: "Oooops... Something went wrong", message: "Impossible to sign in", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertController, animated: true)
        }
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            appNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20)
        ])
    }
}
