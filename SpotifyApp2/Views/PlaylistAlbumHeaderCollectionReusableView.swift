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
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.textColor = .label
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
        
        coverImageView.frame = CGRect(x: 75, y: 0, width: width-150, height: width-150)
        titleLabel.frame = CGRect(x: 10, y: coverImageView.bottom+10, width: width-20, height: 30)
        ownerNameLabel.frame = CGRect(x: 10, y: titleLabel.bottom+5, width: width-20, height: 15)
        descriptionLabel.frame = CGRect(x: 10, y: ownerNameLabel.bottom+10, width: width-20, height: 45)
        detailsLabel.frame = CGRect(x: 10, y: descriptionLabel.bottom+10, width: width-20, height: 15)
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
    
    enum HeaderType {
        case playlist
        case album
    }
}
