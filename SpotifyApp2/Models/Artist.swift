//
//  Artist.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 17.04.23.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let images: [APIImage]?
    let external_urls: [String: String]?
}
