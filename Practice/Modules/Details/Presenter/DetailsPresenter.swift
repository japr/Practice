//
//  MainPresenter.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class DetailsPresenter {
    private let disposeBag = DisposeBag()

    private let movie: Movie

    var wireframe: DetailsWireframeInterface?

    init(movie: Movie) {
        self.movie = movie
    }
}
