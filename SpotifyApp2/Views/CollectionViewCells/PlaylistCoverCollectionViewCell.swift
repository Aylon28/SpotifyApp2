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
        return label
    }()
    
    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
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
        
        coverImageView.frame = CGRect(x: 10, y: 10, width: contentView.width-20, height: contentView.width-20)
        playlistTitleLabel.frame = CGRect(x: 10, y: coverImageView.bottom+10, width: contentView.width-20, height: 20)
        ownerNameLabel.frame = CGRect(x: 10, y: playlistTitleLabel.bottom+5, width: contentView.width-20, height: 20)
    }
    
    func configure(viewModel: PlaylistCoverCollectionViewCellViewModel) {
        playlistTitleLabel.text = viewModel.playlistName
        ownerNameLabel.text = viewModel.ownerName
        coverImageView.sd_setImage(with: viewModel.coverURL)
    }
    
}
