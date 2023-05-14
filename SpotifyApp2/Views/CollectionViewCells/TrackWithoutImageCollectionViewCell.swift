//
//  TrackWithoutImageCollectionViewCell.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 9.04.23.
//

import Foundation
import UIKit

struct TrackWithoutImageCollectionViewCellViewModel {
    let trackTitle: String
    let artistName: String
}

class TrackWithoutImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrackWithoutImageCollectionViewCell"
    
    private let trackTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(trackTitleLabel)
        contentView.addSubview(artistNameLabel)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAnchors()
    }
    
    func configure(viewModel: TrackWithoutImageCollectionViewCellViewModel) {
        artistNameLabel.text = viewModel.artistName
        trackTitleLabel.text = viewModel.trackTitle
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            trackTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            trackTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackTitleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            trackTitleLabel.widthAnchor.constraint(equalToConstant: contentView.width-20),
            
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            artistNameLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
