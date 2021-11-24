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

class MainPresenter {
    private let disposeBag = DisposeBag()
    private let moviesRepository: MoviesRepositoryInterface
    private let loadingState: BehaviorRelay<Bool>
    private let datasource: MainDatasource<Movie, MovieCollectionViewCell>

    var wireframe: MainWireframeInterface?

    struct Input {
        let categorySelected: Driver<Int>
        let itemSelected: Driver<IndexPath>
    }

    struct Output {
        let isInloadingState: Driver<Bool>
        let datasource: MainDatasource<Movie, MovieCollectionViewCell>
    }

    init(repository: MoviesRepositoryInterface) {
        self.moviesRepository = repository
        self.loadingState = BehaviorRelay<Bool>(value: false)
        self.datasource = MainDatasource()
    }

    private func loadMoviesData(with category: MoviesCategory?) {
        moviesRepository.retrieveMovies(with: category).asObservable()
        .subscribe(onNext: { [weak self] movies in
            self?.loadingState.accept(false)
            self?.datasource.setItems(movies, animated: true)
        }, onError: { [weak self] error in
            self?.loadingState.accept(false)
            self?.datasource.setItems([])
        })
        .disposed(by: disposeBag)
    }

    func transform(_ input: Input) -> Output? {
        input.itemSelected
        .drive(onNext: { [weak self] indexPath in
            guard let selectedMovie = self?.datasource.itemAt(indexPath: indexPath) else {
                return
            }
            self?.wireframe?.toMovie(with: selectedMovie)
        })
        .disposed(by: disposeBag)

        input.categorySelected
        .drive(onNext: { [weak self](cat) in
            self?.loadingState.accept(true)
            self?.loadMoviesData(with: MoviesCategory(rawValue: cat))
        })
        .disposed(by: disposeBag)

        return Output(isInloadingState: loadingState.asDriver(), datasource: datasource)
    }
}
