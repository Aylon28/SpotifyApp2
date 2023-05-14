//
//  SignInViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 16.04.23.
//

import Foundation

class SignInViewModel {
    
    var isSignedIn: Bool {
        return AuthenticationManager.Shared.IsSignedIn
    }
}
