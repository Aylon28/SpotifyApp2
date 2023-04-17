//
//  PlaylistDetailsResponse.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String?
    let followers: Followers
    let id: String
    let images: [APIImage]
    let name: String
    let owner: PlaylistOwner
    var tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: Track?
}

struct Followers: Codable {
    let total: Int
}
