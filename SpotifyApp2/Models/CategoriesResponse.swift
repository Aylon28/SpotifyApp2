//
//  CategoriesResponse.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import Foundation

struct CategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let icons: [APIImage]
    let id: String
    let name: String
}
