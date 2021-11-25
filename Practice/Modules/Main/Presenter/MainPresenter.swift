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
    private var currentCategory: MoviesCategory?
    private var currentMovies: [Movie] = []

    var wireframe: MainWireframeInterface?

    struct Input {
        let cancelSearch: Driver<Void>
        let categorySelected: Driver<Int>
        let itemSelected: Driver<IndexPath>
        let searchText: Driver<String?>
    }

    struct Output {
        let isInloadingState: Driver<Bool>
        let datasource: MainDatasource<Movie, MovieCollectionViewCell>
    }

    init(repository: MoviesRepositoryInterface) {
        self.moviesRepository = repository
        self.moviesRepository.subscribeToNetworkChanges()
        self.loadingState = BehaviorRelay<Bool>(value: false)
        self.datasource = MainDatasource()
    }

    private func loadMoviesData(with category: MoviesCategory?) {
        moviesRepository.retrieveMovies(with: category).asObservable()
        .subscribe(onNext: { [weak self] movies in
            self?.loadingState.accept(false)
            self?.datasource.setItems(movies, animated: true)
            self?.currentMovies = movies
        }, onError: { [weak self] error in
            self?.loadingState.accept(false)
            self?.datasource.setItems([])
        })
        .disposed(by: disposeBag)
    }

    private func loadMoviesData(with title: String, and category: MoviesCategory) {
        moviesRepository.retrieveMovies(with: title).asObservable()
        .flatMapLatest { Observable.just($0) }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] list in
            self?.datasource.setItems(list, animated: true)
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
            self?.currentCategory = MoviesCategory(rawValue: cat)
            self?.loadMoviesData(with: MoviesCategory(rawValue: cat))
        })
        .disposed(by: disposeBag)

        input.searchText
        .filter { ($0?.count ?? 0) > 3 }
        .throttle(RxTimeInterval.milliseconds(300))
        .drive(onNext: { [weak self] text in
            guard let title = text, !title.isEmpty else { return }
            self?.loadMoviesData(with: title, and: self?.currentCategory ?? .popular)
        })
        .disposed(by: disposeBag)

        input.cancelSearch
        .drive(onNext: { [weak self] in
            self?.datasource.setItems(self?.currentMovies ?? [], animated: true)
        })
        .disposed(by: disposeBag)

        return Output(isInloadingState: loadingState.asDriver(), datasource: datasource)
    }
}
