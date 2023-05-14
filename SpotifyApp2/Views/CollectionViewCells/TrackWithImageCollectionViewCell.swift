//
//  TrackWithImageCollectionViewCell.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import UIKit

struct TrackWithImageCollectionViewCellViewModel {
    let trackTitle: String
    let artistName: String
    let coverImageURL: URL?
}

class TrackWithImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackWithImageCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(trackTitleLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(coverImageView)
        contentView.backgroundColor = .secondarySystemBackground
        setAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(viewModel: TrackWithImageCollectionViewCellViewModel) {
        artistNameLabel.text = viewModel.artistName
        trackTitleLabel.text = viewModel.trackTitle
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            coverImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: contentView.height),
            coverImageView.widthAnchor.constraint(equalToConstant: contentView.height),
            
            trackTitleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            trackTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackTitleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackTitleLabel.widthAnchor.constraint(equalToConstant: contentView.width-coverImageView.width-20),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            artistNameLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
