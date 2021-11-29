//
//  MoviesRepositoryMock.swift
//  PracticeTests
//
//  Created by Jorge Palacio on 11/29/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import XCTest
import RxSwift
@testable import Practice

class MoviesRepositoryMock: MoviesRepositoryInterface {

    let disposeBag = DisposeBag()
    let mockedMovie = Movie(id: 0,
                            overview: "Mocked movie",
                            posterPath: "http://fakeimage",
                            releaseDate: "10/22/19",
                            title: "Testable movie",
                            videoAvailable: false,
                            votesAverage: 9.6,
                            movieVideos: nil)
    let mockedVideo = MovieVideo(id: "0",
                                 key: "sdasdklj",
                                 name: "Mocked video ",
                                 site: "Youtube",
                                 type: "normal")

    let networkMock = NetworkConnectionMock()
    var networkReachable: NetworkStatus = .reachable

    func retrieveMovies(with category: MoviesCategory?) -> Single<[Movie]> {
        return Single.just([mockedMovie])
    }

    func retrieveMovies(with title: String) -> Single<[Movie]> {
        return Single.just([mockedMovie])
    }

    func retrieveMovieVideosWith(id: String) -> Single<[MovieVideo]> {
        return Single.just([mockedVideo])
    }

    func subscribeToNetworkChanges() {
        networkMock.subscribeToNetworkStatusChanges().asObservable()
        .subscribe(onNext: { [weak self] (status) in
            self?.networkReachable = status
        }).disposed(by: disposeBag)
    }
}
