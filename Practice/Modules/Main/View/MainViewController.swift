//
//  MainViewController.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet var categoriesControl: UISegmentedControl!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private let disposeBag = DisposeBag()

    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier()
        )
        let categorySelected = categoriesControl.rx.selectedSegmentIndex.asDriver()
        let itemSelected = collectionView.rx.itemSelected.asDriver()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in }.asDriver(onErrorJustReturn: ())
        let input = MainPresenter.Input(categorySelected: categorySelected, itemSelected: itemSelected, viewWillAppear: viewWillAppear)

        let output = presenter?.transform(input)
        output?.isInloadingState.drive(onNext: { [weak self](loading) in
            loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        })
        .disposed(by: disposeBag)
        output?.isInloadingState.drive(collectionView.rx.isHidden).disposed(by: disposeBag)
    }
}
