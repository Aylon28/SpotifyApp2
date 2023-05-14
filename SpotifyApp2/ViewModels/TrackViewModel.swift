//
//  TrackViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 15.04.23.
//

import Foundation

class TrackViewModel {
    var track: Track?
    
    init(track: Track) {
        self.track = track
    }
    
    func addTrackButtonTapped(_ playlistId: String) {
        guard let id = track?.id else { return }
        APICallerTracks.Shared.SaveTrackWith(id, to: playlistId) { result in
            if result {
                HapticsManager.Shared.Vibrate(for: .success)
            }
        }
    }
}
