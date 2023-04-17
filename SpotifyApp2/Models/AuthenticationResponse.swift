//
//  AuthenticationResponse.swift
//  koijhu
//
//  Created by Ilona Punya on 14.04.23.
//

import Foundation

struct AuthenticationResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let token_type: String
}
