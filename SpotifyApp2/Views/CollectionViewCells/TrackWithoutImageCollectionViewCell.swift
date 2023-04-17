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
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackTitleLabel.frame = CGRect(x: 10,
                                       y: 0,
                                       width: contentView.width-20,
                                       height: contentView.height/2)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: contentView.height/2,
                                       width: contentView.width-20,
                                       height: contentView.height/2)
    }
    
    func configure(viewModel: TrackWithoutImageCollectionViewCellViewModel) {
        artistNameLabel.text = viewModel.artistName
        trackTitleLabel.text = viewModel.trackTitle
    }
}
