//
//  PlaylistCoverCollectionViewCell.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 8.04.23.
//

import UIKit

struct PlaylistCoverCollectionViewCellViewModel {
    let playlistName: String
    let ownerName: String
    let coverURL: URL?
}

class PlaylistCoverCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaylistCoverCollectionViewCell"
    
    private let playlistTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(playlistTitleLabel)
        contentView.addSubview(ownerNameLabel)
        contentView.addSubview(coverImageView)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAnchors()
    }
    
    func configure(viewModel: PlaylistCoverCollectionViewCellViewModel) {
        playlistTitleLabel.text = viewModel.playlistName
        ownerNameLabel.text = viewModel.ownerName
        coverImageView.sd_setImage(with: viewModel.coverURL)
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            coverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            coverImageView.heightAnchor.constraint(equalToConstant: contentView.width-20),
            coverImageView.widthAnchor.constraint(equalToConstant: contentView.width-20),
            
            playlistTitleLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            playlistTitleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 10),
            playlistTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            ownerNameLabel.topAnchor.constraint(equalTo: playlistTitleLabel.bottomAnchor, constant: 5),
            ownerNameLabel.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor)
        ])
    }
    
}
