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

    private let connection: NetworkConnection = .default

    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        posterImageView.image = nil
        titleLabel.text = nil
        votesLabel.text = nil
    }
}

extension MovieCollectionViewCell: ConfigurableCell {
    typealias Element = Movie

    func configure(with item: Movie) {
        titleLabel.text = item.title
        descriptionLabel.text = item.overview
        descriptionLabel.sizeToFit()
        votesLabel.text = "Votes: \(item.votesAverage)"

        guard let poster = item.posterPath else { return }

        connection.getImage(poster) { [weak self] result in
            switch result {
            case .failure(_): return
            case let .success(data):
                DispatchQueue.main.async {
                    self?.posterImageView.image = UIImage(data: data, scale: 1.0)
                }
            }
        }
    }
}
