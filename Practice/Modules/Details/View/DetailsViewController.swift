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

class DetailsViewController: UIViewController {

    private let disposeBag = DisposeBag()

    var presenter: DetailsPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        bindPresenter()
    }

    private func setupBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = "Search"
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

    private func bindPresenter() {
        let output = presenter?.transform(DetailsPresenter.Input())
        output?.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
    }
}
