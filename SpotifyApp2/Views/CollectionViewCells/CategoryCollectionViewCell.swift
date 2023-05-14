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
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.layer.zPosition = 5
        label.translatesAutoresizingMaskIntoConstraints = false
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
        setAnchors()
    }
    
    func configure(viewModel: CategoryCollectionViewCellViewModel) {
        categoryTitleLabel.text = viewModel.categoryTitle
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
        coverImageView.transform = CGAffineTransform(rotationAngle: .pi/6)
        
        contentView.backgroundColor = colors.randomElement()
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            coverImageView.heightAnchor.constraint(equalToConstant: contentView.width/2.2),
            coverImageView.widthAnchor.constraint(equalToConstant: contentView.width/2.2),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: contentView.width*0.05),
            
            categoryTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            categoryTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            categoryTitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            categoryTitleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
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
