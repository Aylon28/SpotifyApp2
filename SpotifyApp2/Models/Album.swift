//
//  Album.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 17.04.23.
//

import Foundation

struct Album: Codable {
    let total_tracks: Int
    let external_urls: [String: String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let artists: [Artist]
    let popularity: Int?
    let tracks: TrackResponse?
}
