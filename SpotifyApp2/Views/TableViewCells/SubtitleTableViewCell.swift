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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
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
        setAnchors()
    }
   
    func configure(viewModel: SubtitleTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        coverImageView.sd_setImage(with: viewModel.coverImageURL)
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            coverImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            coverImageView.widthAnchor.constraint(equalToConstant: contentView.height-10),
            coverImageView.heightAnchor.constraint(equalToConstant: contentView.height-10),
            
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 10),
            subtitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10),
            subtitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

}
