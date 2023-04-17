//
//  TrackControlsView.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 12.04.23.
//

import Foundation
import UIKit

class TrackControlsView: UIView {
    var viewModel = TrackControlsViewModel()
    
    private let prevSongButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34)), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let nextSongButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34)), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let playPauseSongButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 38)), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .systemGreen
        slider.value = 0.2
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(prevSongButton)
        addSubview(nextSongButton)
        addSubview(playPauseSongButton)
        addSubview(volumeSlider)
        playPauseSongButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        prevSongButton.frame = CGRect(x: 20, y: 0, width: 70, height: 70)
        playPauseSongButton.frame = CGRect(x: (width/2)-35, y: 0, width: 70, height: 70)
        nextSongButton.frame = CGRect(x: width-20-70, y: 0, width: 70, height: 70)
        volumeSlider.frame = CGRect(x: 20, y: prevSongButton.bottom+20, width: width-40, height: 20)
    }
    
    @objc private func didSlideSlider() {
        viewModel.didSlideSlider(volumeSlider.value)
    }
    
    @objc private func didTapPlayPause() {
        viewModel.isPlaying = !viewModel.isPlaying
        if viewModel.isPlaying {
            playPauseSongButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 38)), for: .normal)
        } else {
            playPauseSongButton.setImage(UIImage(systemName: "play", withConfiguration: UIImage.SymbolConfiguration(pointSize: 38)), for: .normal)
        }
        viewModel.didTapPlayPauseSong()
    }
}
