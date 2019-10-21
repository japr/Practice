//
//  MainPresenter.swift
//  Practice
//
//  Created by Jorge Palacio on 10/21/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DetailsPresenter {
    private let disposeBag = DisposeBag()

    private let movie: Movie

    var wireframe: DetailsWireframeInterface?

    struct Input {

    }

    struct Output {
        let title: BehaviorRelay<String>
    }

    init(movie: Movie) {
        self.movie = movie
    }

    func transform(_ input: Input) -> Output {
        let titleRelay = BehaviorRelay<String>(value: movie.title)
        return Output(title: titleRelay)
    }
}
