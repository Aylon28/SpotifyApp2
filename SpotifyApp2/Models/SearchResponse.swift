//
//  SearchResponse.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 10.04.23.
//

import Foundation

struct SearchResponse: Codable {
    let albums: AlbumResponse
    let playlists: PlaylistResponse
    let artists: ArtistResponse
    let tracks: TrackResponse
}


