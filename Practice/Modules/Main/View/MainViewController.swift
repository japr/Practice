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
    private let searchController = UISearchController(searchResultsController: nil)

    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        bindPresenter()
        setupSearchController()

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        collectionView.delegate = self
    }

    private func bindPresenter() {
        let categorySelected = categoriesControl.rx.selectedSegmentIndex.asDriver()
        let itemSelected = collectionView.rx.itemSelected.asDriver()
        let searchBarInput = searchController.searchBar.rx.text.asDriver()
        let cancelSearchInput = searchController.searchBar.rx.cancelButtonClicked.asDriver()
        let input = MainPresenter.Input(
            cancelSearch: cancelSearchInput,
            categorySelected: categorySelected,
            itemSelected: itemSelected,
            searchText: searchBarInput
        )

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
            self?.collectionView.setContentOffset(.zero, animated: false)
            self?.collectionView.collectionViewLayout.invalidateLayout()
            self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }

    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400.0)
    }
}
