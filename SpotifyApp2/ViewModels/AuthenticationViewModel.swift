//
//  AuthenticationViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 16.04.23.
//

import Foundation

class AuthenticationViewModel {
    var completionHandler: ((Bool) -> Void)?
    
    func changeCodeForToken(_ code: String, completion: @escaping (Bool) -> Void) {
        AuthenticationManager.shared.changeCodeForToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                if result {
                    self?.completionHandler?(result)
                    completion(true)
                }
            }
        }
    }
}
