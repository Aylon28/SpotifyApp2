//
//  TrackViewController.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 11.04.23.
//

import SDWebImage
import UIKit

class TrackViewController: UIViewController {
    var viewModel: TrackViewModel!
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let popularityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackControlsView = TrackControlsView()
    
    init(viewModel: Track) {
        self.viewModel = TrackViewModel(track: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAnchors()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(coverImageView)
        view.addSubview(trackNameLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(trackControlsView)
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        
        title = viewModel.track?.name ?? ""

        coverImageView.sd_setImage(with: URL(string: viewModel.track?.album?.images.first?.url ?? ""))
        trackNameLabel.text = viewModel.track?.name
        artistNameLabel.text = viewModel.track?.artists.first?.name
        if let popularity = viewModel.track?.popularity {
            view.addSubview(popularityLabel)
            popularityLabel.text = "Song popularity: \(popularity)"
        }
    }
    
    @objc private func addButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            let vc = LibraryViewController(playlistsAreOwnedByUser: true)
            vc.viewModel.playlistSelectionHandler = { playlistId in
                self?.viewModel.addTrackButtonTapped(playlistId)
            }
            self?.present(vc, animated: true)
        }
    }
    
    private func setAnchors() {
        let imageSize = view.width-40
        trackControlsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            coverImageView.widthAnchor.constraint(equalToConstant: imageSize),
            coverImageView.heightAnchor.constraint(equalToConstant: imageSize),
            
            trackNameLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            trackNameLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 15),
            trackNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 10),
            
            popularityLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            popularityLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 10),
            
            trackControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackControlsView.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 60),
            trackControlsView.widthAnchor.constraint(equalToConstant: view.width),
            trackControlsView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}
