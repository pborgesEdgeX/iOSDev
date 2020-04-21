//
//  DataView.swift
//  covid19
//
//  Created by Daniel on 4/9/20.
//  Copyright © 2020 dk. All rights reserved.
//

import UIKit

class DataView: UICollectionReusableView {
    static let identifier = "DataCell"

    var color = UIColor.black

    let countryLabel = UILabel()
    let casesLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        configure()

        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        casesLabel.attributedText = nil
        countryLabel.attributedText = nil
    }
}

private extension DataView {
    func configure() {
        self.addSubview(countryLabel)
        countryLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(casesLabel)
        casesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: self.topAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            casesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            casesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            casesLabel.heightAnchor.constraint(equalToConstant: 60),
            casesLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor)
        ])
    }

    private func setup() {
        countryLabel.textColor = color
    }
}
