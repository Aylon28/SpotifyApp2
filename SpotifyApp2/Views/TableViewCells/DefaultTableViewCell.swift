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
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
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
        
        coverImageView.frame = CGRect(x: 5, y: 5, width: contentView.height-10, height: contentView.height-10)
        titleLabel.frame = CGRect(x: coverImageView.right+10,
                                  y: 0,
                                  width: contentView.width-coverImageView.width-20,
                                  height: contentView.height)
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

}
