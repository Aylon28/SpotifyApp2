//
//  AuthenticationViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 6.04.23.
//

import UIKit
import WebKit

class AuthenticationViewController: UIViewController, WKNavigationDelegate {
    var viewModel = AuthenticationViewModel()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.navigationDelegate = self
        guard let url = AuthenticationManager.Shared.GetAccessCodeURL() else { return }
        webView.load(url)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let urlString = webView.url?.absoluteString else { return }
        let components = URLComponents(string: urlString)
        guard let code = components?.queryItems?.first(where: { $0.name == "code" })?.value else { return }
        webView.isHidden = true
        viewModel.changeCodeForToken(code) { [weak self] result in
            if result {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

}

