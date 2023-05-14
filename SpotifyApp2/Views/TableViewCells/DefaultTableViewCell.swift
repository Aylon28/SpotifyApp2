//
//  DefaultTableViewCell.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 11.04.23.
//

import UIKit

struct DefaultTableViewCellViewModel {
    let title: String
    let coverImageURL: URL?
}

struct DefaultTableViewSystemImageCellViewModel {
    let title: String
    let coverImage: String
}

class DefaultTableViewCell: UITableViewCell {
    static let identifier = "DefaultTableViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAnchors()
    }
   
    func configure(viewModel: DefaultTableViewCellViewModel, isRounded: Bool = false) {
        titleLabel.text = viewModel.title
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
        
        if isRounded {
            coverImageView.layer.cornerRadius = (contentView.height-10)/2
            coverImageView.layer.masksToBounds = true
        }
    }
    
    func configure(viewModel: DefaultTableViewSystemImageCellViewModel) {
        titleLabel.text = viewModel.title
        coverImageView.image = UIImage(systemName: viewModel.coverImage)
        coverImageView.tintColor = .label
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            coverImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            coverImageView.widthAnchor.constraint(equalToConstant: contentView.height-10),
            coverImageView.heightAnchor.constraint(equalToConstant: contentView.height-10),
            
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
