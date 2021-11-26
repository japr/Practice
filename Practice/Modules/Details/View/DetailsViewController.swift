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
        bindPresenter()
    }

    private func bindPresenter() {

    }
}
