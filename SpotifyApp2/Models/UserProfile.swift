//
//  UserProfile.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 12.04.23.
//

import Foundation

struct UserProfile: Codable {
    let display_name: String
    let country: String
    let email: String
    let product: String
    let id: String
    let followers: Followers
    let images: [APIImage]
}
