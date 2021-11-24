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

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        let categorySelected = categoriesControl.rx.selectedSegmentIndex.asDriver()
        let itemSelected = collectionView.rx.itemSelected.asDriver()
        let input = MainPresenter.Input(categorySelected: categorySelected, itemSelected: itemSelected)

        let output = presenter?.transform(input)
        collectionView.dataSource = output?.datasource
        output?.isInloadingState.drive(onNext: { [weak self](loading) in
            loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            self?.collectionView.isHidden = loading
        })
        .disposed(by: disposeBag)
        let itemsSet = output?.datasource.uiUpdateRequired.asDriver()
        itemsSet?
        .drive(onNext: { [weak self] _ in
            self?.collectionView.collectionViewLayout.invalidateLayout()
            self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }
}
