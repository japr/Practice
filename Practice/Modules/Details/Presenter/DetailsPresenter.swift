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
    private let moviesRepository: MoviesRepositoryInterface
    private var movieVideos: [MovieVideo] = []
    private let movieCoverRelay = BehaviorRelay<UIImage?>(value: nil)
    private let networkManager: NetworkInferface

    var wireframe: DetailsWireframeInterface?

    struct Input {

    }

    struct Output {
        let complementaryInfo: BehaviorRelay<String>
        let title: BehaviorRelay<String>
        let movieCover: BehaviorRelay<UIImage?>
        let movieDescription: BehaviorRelay<String>
    }

    init(movie: Movie,
         moviesRepository: MoviesRepositoryInterface,
         networkManager: NetworkInferface = NetworkConnection.default) {
        self.movie = movie
        self.moviesRepository = moviesRepository
        self.moviesRepository.subscribeToNetworkChanges()
        self.networkManager = networkManager
    }

    func transform(_ input: Input) -> Output {
        moviesRepository.retrieveMovieVideosWith(id: movie.id.description).asObservable()
        .subscribe(onNext: { [weak self](videosList) in
            self?.movieVideos = videosList
        })
        .disposed(by: disposeBag)

        if let posterPath = movie.posterPath {
            networkManager.getImage(posterPath) { [weak self] result in
                switch result {
                case .failure(_): return
                case let .success(data):
                    guard let image = UIImage(data: data, scale: 1.0) else { return }
                    self?.movieCoverRelay.accept(image)
                }
            }
        }

        let titleRelay = BehaviorRelay<String>(value: movie.title)
        let descriptionRelay = BehaviorRelay<String>(value: movie.overview)
        let info = BehaviorRelay<String>(value: "Release date: \(movie.releaseDate ?? "") - Votes: \(movie.votesAverage)")

        return Output(complementaryInfo: info,
                      title: titleRelay,
                      movieCover: movieCoverRelay,
                      movieDescription: descriptionRelay)
    }
}
