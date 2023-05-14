//
//  UsersTopItemsCollectionViewCell.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 8.04.23.
//

import SDWebImage
import UIKit

struct NewReleasesCollectionViewCellViewModel {
    let title: String
    let coverImageURL: URL?
}

class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    
    private let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
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
        
        contentView.addSubview(albumTitleLabel)
        contentView.addSubview(coverImageView)
        setAnchors()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(viewModel: NewReleasesCollectionViewCellViewModel) {
        albumTitleLabel.text = viewModel.title
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    private func setAnchors() {
        let imageSize = contentView.height
        
        NSLayoutConstraint.activate([
            coverImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: imageSize),
            coverImageView.widthAnchor.constraint(equalToConstant: imageSize),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            albumTitleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            albumTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            albumTitleLabel.widthAnchor.constraint(equalToConstant: contentView.width-imageSize-10)
        ])
    }
}
