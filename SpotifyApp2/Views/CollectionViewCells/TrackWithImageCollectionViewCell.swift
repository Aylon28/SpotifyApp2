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
        return imageView
    }()
    
    private let trackTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(trackTitleLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(coverImageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.frame = CGRect(x: 0, y: 0, width: contentView.height, height: contentView.height)
        trackTitleLabel.frame = CGRect(x: coverImageView.right+10,
                                       y: 0,
                                       width: contentView.width-coverImageView.height-20,
                                       height: contentView.height/2)
        artistNameLabel.frame = CGRect(x: coverImageView.right+10,
                                       y: contentView.height/2,
                                       width: contentView.width-coverImageView.height-20,
                                       height: contentView.height/2)
    }
    
    func configure(viewModel: TrackWithImageCollectionViewCellViewModel) {
        artistNameLabel.text = viewModel.artistName
        trackTitleLabel.text = viewModel.trackTitle
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
    }
}
