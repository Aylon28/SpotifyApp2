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
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let popularityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
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
        
        let imageSize = view.width-40
        coverImageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top+10, width: imageSize, height: imageSize)
        trackNameLabel.frame = CGRect(x: 20, y: coverImageView.bottom+15, width: view.width-40, height: 20)
        artistNameLabel.frame = CGRect(x: 20, y: trackNameLabel.bottom+10, width: view.width-40, height: 20)
        popularityLabel.frame = CGRect(x: 20, y: artistNameLabel.bottom+10, width:  view.width-40, height: 12)
        trackControlsView.frame = CGRect(x: 0, y: artistNameLabel.bottom+60, width: view.width, height: 120)
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
}
