//
//  MovieCollectionViewCell.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!
}

extension MovieCollectionViewCell: ConfigurableCell {
    typealias Element = Movie

    func configure(with item: Movie) {
        titleLabel.text = item.title
        descriptionLabel.text = item.overview
        votesLabel.text = "Votes: \(item.votesAverage)"
    }
}
