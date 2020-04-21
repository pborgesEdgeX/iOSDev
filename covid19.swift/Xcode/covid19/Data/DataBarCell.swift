//
//  DataBarCell.swift
//  covid19
//
//  Created by Daniel on 4/9/20.
//  Copyright © 2020 dk. All rights reserved.
//

import UIKit

class DataBarCell: UICollectionViewCell {
    static let identifier = "DataBarCell"

    var color = UIColor.black

    var height: CGFloat = 44

    private let barView = UIView()

    override func layoutSubviews() {
        super.layoutSubviews()

        configure()
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        barView.removeConstraints(barView.constraints)
    }
}

private extension DataBarCell {
    func configure() {
        self.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            barView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            barView.heightAnchor.constraint(equalToConstant: height),
            barView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            barView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setup() {
        barView.backgroundColor = color
    }
}
