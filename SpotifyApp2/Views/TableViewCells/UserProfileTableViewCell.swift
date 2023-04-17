//
//  UserProfileTableViewCell.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 12.04.23.
//

import UIKit

struct UserProfileTableViewCellViewModel {
    let title: String
    let value: String
}

class UserProfileTableViewCell: UITableViewCell {
    static let identifier = "UserProfileTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10,
                                  y: 0,
                                  width: contentView.width/3,
                                  height: contentView.height)
        valueLabel.frame = CGRect(x: contentView.width/3-10,
                                  y: 0,
                                  width: contentView.width-contentView.width/3,
                                  height: contentView.height)
    }
   
    func configure(viewModel: UserProfileTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }

}
