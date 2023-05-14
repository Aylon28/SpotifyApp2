//
//  SectionTitleCollectionReusableView.swift
//  SpotifyApp2
//
//  Created by Ilona Punya on 8.04.23.
//

import UIKit

class SectionTitleCollectionReusableView: UICollectionReusableView {
    static let identifier = "SectionTitleCollectionReusableView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAnchors()
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    private func setAnchors() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
}
