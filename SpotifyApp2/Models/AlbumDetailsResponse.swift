//
//  AlbumDetailsResponse.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let total_tracks: Int
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let popularity: Int
    let artists: [Artist]
    let tracks: TrackResponse
}
