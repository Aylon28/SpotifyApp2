//
//  Playlist.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 17.04.23.
//

import Foundation

struct Playlist: Codable {
    let id: String
    let images: [APIImage]
    let owner: PlaylistOwner
    let name: String
}
