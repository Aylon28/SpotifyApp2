//
//  TrackControlsViewModel.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 17.04.23.
//

import Foundation

class TrackControlsViewModel {
    var isPlaying: Bool = true
    
    func didTapPlayPauseSong() {
        PlaybackPresenter.shared.playPause()
    }
    
    func didSlideSlider(_ value: Float) {
        PlaybackPresenter.shared.setVolume(value)
    }
}
