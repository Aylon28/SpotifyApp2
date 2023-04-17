//
//  UserAlbumsResponse.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 11.04.23.
//

import Foundation

struct UserAlbumsResponse: Codable {
    let items: [UserAlbumResponse]
}

struct UserAlbumResponse: Codable {
    let album: Album
}
