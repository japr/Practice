//
//  MainPresenter.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation
import RxSwift

class MainPresenter {
    private let disposeBag = DisposeBag()
    private let moviesRepository: MoviesRepositoryInterface

    var wireframe: MainWireframeInterface?

    init(repository: MoviesRepositoryInterface) {
        self.moviesRepository = repository
    }

    func loadMoviesData() {
        moviesRepository.retrieveMovies().asObservable()
            .subscribe(onNext: { (movies) in
                
            }, onError: { (error) in

            }).disposed(by: disposeBag)
    }
}
