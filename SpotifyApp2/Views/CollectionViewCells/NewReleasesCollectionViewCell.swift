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
        
        contentView.addSubview(albumTitleLabel)
        contentView.addSubview(coverImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.frame = CGRect(x: 0, y: 0, width: contentView.height, height: contentView.height)
        albumTitleLabel.frame = CGRect(x: coverImageView.right+10,
                                       y: 0,
                                       width: contentView.width-coverImageView.height-20,
                                       height: contentView.height)
    }
    
    func configure(viewModel: NewReleasesCollectionViewCellViewModel) {
        albumTitleLabel.text = viewModel.title
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
}
