//
//  PlaylistAlbumHeaderCollectionReusableView.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import UIKit

struct PlaylistAlbumHeaderCollectionReusableViewViewModel {
    let name: String
    let owner: String
    let artworURL: URL?
    let supplemetryInfo: Int?
    let description: String
}

class PlaylistAlbumHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistAlbumHeaderCollectionReusableView"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImageView)
        addSubview(titleLabel)
        addSubview(ownerNameLabel)
        addSubview(detailsLabel)
        addSubview(descriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAnchors()
    }
    
    func configure(viewModel: PlaylistAlbumHeaderCollectionReusableViewViewModel, headerType: HeaderType) {
        coverImageView.sd_setImage(with: viewModel.artworURL)
        titleLabel.text = viewModel.name
        ownerNameLabel.text = viewModel.owner
        switch headerType {
        case .album:
            if let totalTracks = viewModel.supplemetryInfo {
                detailsLabel.text = "Total tracks: \(totalTracks)"
            }
            descriptionLabel.text = "Release date: \(viewModel.description)"
        case .playlist:
            if let followers = viewModel.supplemetryInfo {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                guard let formattedNumber = numberFormatter.string(from: NSNumber(value: followers)) else { return }
                detailsLabel.text = "Followers: \(formattedNumber)"
            }
            descriptionLabel.text = viewModel.description
        }
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            coverImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.widthAnchor.constraint(equalToConstant: width-130),
            coverImageView.heightAnchor.constraint(equalToConstant: width-130),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 10),
            
            ownerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ownerNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: ownerNameLabel.bottomAnchor, constant: 5),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 43),
            
            detailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            detailsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5)
        ])
    }
    
    enum HeaderType {
        case playlist
        case album
    }
}
