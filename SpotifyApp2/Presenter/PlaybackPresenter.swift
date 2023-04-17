//
//  PlaybackPresenter.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 13.04.23.
//

import AVFoundation
import Foundation
import UIKit

class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var player: AVPlayer?

    func playSong(track: Track, completion: @escaping (Bool) -> Void) {
        if player != nil {
            player!.pause()
        }

        guard let url = URL(string: track.preview_url ?? "") else {
            completion(false)
            return
        }

        player = AVPlayer(url: url)
        player?.volume = 0.2
        player?.play()
        completion(true)
    }

    func setVolume(_ value: Float) {
        guard player != nil else { return }
        player!.volume = value
    }

    func playPause() {
        guard player != nil else { return }
        if player!.timeControlStatus == .playing {
            player!.pause()
        } else {
            player!.play()
        }
    }

}
