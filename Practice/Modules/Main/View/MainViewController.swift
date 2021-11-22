//
//  MainViewController.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var categoriesControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!

    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier()
        )

        presenter?.loadMoviesData()
    }
}
