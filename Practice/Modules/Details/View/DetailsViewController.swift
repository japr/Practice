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
import WebKit

class DetailsViewController: UITableViewController {

    @IBOutlet var additionalInfoLabel: UILabel!
    @IBOutlet var movieCover: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var webView: WKWebView!

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
        output?.complementaryInfo.bind(to: additionalInfoLabel.rx.text).disposed(by: disposeBag)
        output?.title.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        output?.movieDescription.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        output?.movieCover.bind(to: movieCover.rx.image).disposed(by: disposeBag)
        output?.trailerURL
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] request in
            guard let validReq = request else { return }
            self?.webView.load(validReq)
        })
        .disposed(by: disposeBag)
    }
}
