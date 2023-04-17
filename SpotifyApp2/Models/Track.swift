//
//  Track.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 17.04.23.
//

import Foundation

struct Track: Codable {
    var album: Album?
    let artists: [Artist]
    let id: String
    let preview_url: String?
    let is_playable: Bool?
    let name: String
    let popularity: Int?
}
