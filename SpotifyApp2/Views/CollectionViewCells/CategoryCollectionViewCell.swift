//
//  CategoryCollectionViewCell.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import UIKit

struct CategoryCollectionViewCellViewModel {
    let categoryTitle: String
    let coverImageURL: URL?
}

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.layer.zPosition = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(categoryTitleLabel)
        contentView.addSubview(coverImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.frame = CGRect(x: contentView.width/1.6, y: contentView.height/2, width: contentView.width/3, height: contentView.width/3)
        categoryTitleLabel.frame = CGRect(x: 10,
                                          y: 10,
                                          width: contentView.width-20,
                                          height: 40)
    }
    
    func configure(viewModel: CategoryCollectionViewCellViewModel) {
        categoryTitleLabel.text = viewModel.categoryTitle
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
        coverImageView.transform = CGAffineTransform(rotationAngle: .pi/6)
        
        contentView.backgroundColor = colors.randomElement()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemGreen,
        .systemRed,
        .systemOrange,
        .systemBlue,
        .systemPurple,
        .systemBrown,
        .systemTeal
    ]
}
