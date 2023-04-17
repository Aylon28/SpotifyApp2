//
//  SettingsModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 12.04.23.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let iconSystemName: String
    let handler: () -> Void
}
