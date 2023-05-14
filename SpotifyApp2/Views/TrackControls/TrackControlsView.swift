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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextSongButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34)), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playPauseSongButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 38)), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .systemGreen
        slider.value = 0.2
        slider.translatesAutoresizingMaskIntoConstraints = false
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
        setAnchors()
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
    
    private func setAnchors() {
        let controllerHeight: CGFloat = 70
        NSLayoutConstraint.activate([
            prevSongButton.topAnchor.constraint(equalTo: topAnchor),
            prevSongButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            prevSongButton.heightAnchor.constraint(equalToConstant: controllerHeight),
            prevSongButton.widthAnchor.constraint(equalToConstant: controllerHeight),
            
            playPauseSongButton.topAnchor.constraint(equalTo: topAnchor),
            playPauseSongButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseSongButton.heightAnchor.constraint(equalToConstant: controllerHeight),
            playPauseSongButton.widthAnchor.constraint(equalToConstant: controllerHeight),
            
            nextSongButton.topAnchor.constraint(equalTo: topAnchor),
            nextSongButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            nextSongButton.heightAnchor.constraint(equalToConstant: controllerHeight),
            nextSongButton.widthAnchor.constraint(equalToConstant: controllerHeight),
            
            volumeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            volumeSlider.topAnchor.constraint(equalTo: prevSongButton.bottomAnchor, constant: 20),
            volumeSlider.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
            volumeSlider.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
