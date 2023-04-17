//
//  SubtitleTableViewCell.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 11.04.23.
//

import UIKit

struct SubtitleTableViewCellViewModel {
    let title: String
    let subtitle: String
    let coverImageURL: URL?
}

class SubtitleTableViewCell: UITableViewCell {
    static let identifier = "SubtitleTableViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "house")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
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
                                  height: contentView.height/2)
        subtitleLabel.frame = CGRect(x: coverImageView.right+10,
                                     y: contentView.height/2,
                                     width: contentView.width-coverImageView.width-20,
                                     height: contentView.height/2)
    }
   
    func configure(viewModel: SubtitleTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
    }

}
