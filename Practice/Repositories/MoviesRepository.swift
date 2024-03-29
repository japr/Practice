//
//  MoviesRepository.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation
import RxSwift

protocol MoviesRepositoryInterface {
    func retrieveMovies(with category: MoviesCategory?) -> Single<[Movie]>
    func retrieveMovies(with title: String) -> Single<[Movie]>
    func retrieveMovieVideosWith(id: String) -> Single<[MovieVideo]>
    func subscribeToNetworkChanges()
}

enum MoviesCategory: Int {
    case popular
    case topRated
    case upcoming
}

enum MoviesRepositoryErrors: Error {
    case badData
    case cachedMovieNotFound
}

class MoviesRepository {

    var currentNetworkStatus: NetworkStatus = .reachable
    private let database: Database
    private let disposeBag = DisposeBag()
    private let network: NetworkInferface

    init(database: Database = .default, network: NetworkInferface = NetworkConnection.default) {
        self.database = database
        self.network = network
    }

    private func getList(from data: Data) -> List? {
        do {
            let list = try JSONDecoder().decode(List.self, from: data)
            return list
        } catch _ {
            return nil
        }
    }

    private func saveListToDB(category: MoviesCategory?, movies: [Movie], observer: @escaping ((SingleEvent<[Movie]>) -> Void)) {
        let context = Database.temporaryContext()
        Database.sharedQueue.async {
            let entities = movies.compactMap { [weak self] movie -> CachedMovie? in
                guard let strongSelf = self else { return nil }

                do {
                    let cachedMovie: CachedMovie = try strongSelf.database.insertNewEntity(in: context)
                    cachedMovie.update(from: movie, and: category ?? .popular)
                    return cachedMovie
                } catch _ { return nil }
            }
            self.database.save(entities, in: context) { (error) in
                guard let error = error else {
                    observer(.success(movies))
                    return
                }
                observer(.error(error))
            }
        }
    }

    private func saveMovieVideosToDB(movieId: String, movieVideos: [MovieVideo], observer: @escaping ((SingleEvent<[MovieVideo]>) -> Void)) {
        let context = Database.temporaryContext()
        Database.sharedQueue.async {
            let entities = movieVideos.compactMap { [weak self] movie -> CachedMovieVideo? in
                guard let strongSelf = self else { return nil }

                do {
                    let cachedVideo: CachedMovieVideo = try strongSelf.database.insertNewEntity(in: context)
                    cachedVideo.update(from: movie)
                    return cachedVideo
                } catch _ { return nil }
            }
            let predicate = NSPredicate(format: "id == '\(movieId)'")
            guard let cachedMovies: [CachedMovie] = Database.loadEntities(in: context, with: predicate),
                let savedMovie = cachedMovies.first else {
                observer(.error(MoviesRepositoryErrors.cachedMovieNotFound))
                return
            }
            savedMovie.movieVideos?.addingObjects(from: entities)
            self.database.save([savedMovie], in: context) { (error) in
                guard let error = error else {
                    observer(.success(movieVideos))
                    return
                }
                observer(.error(error))
            }
        }
    }

    private func loadLocalMovies(with predicate: NSPredicate, observer: @escaping ((SingleEvent<[Movie]>) -> Void)) {
        let context = Database.temporaryContext()
        Database.sharedQueue.async {
            let cachedMovies: [CachedMovie] = Database.loadEntities(in: context, with: predicate) ?? []
            let movies = cachedMovies.compactMap { cached -> Movie? in
                let movie: Movie? = cached.map()
                return movie
            }
            observer(.success(movies))
        }
    }

    private func loadLocalMovieVideos(with predicate: NSPredicate, observer: @escaping ((SingleEvent<[MovieVideo]>) -> Void)) {
        let context = Database.temporaryContext()
        Database.sharedQueue.async {
            let foundMovie: [CachedMovie] = Database.loadEntities(in: context, with: predicate) ?? []
            guard let cachedMovie = foundMovie.first else {
                observer(.success([]))
                return
            }
            let movies = cachedMovie.movieVideos?.compactMap { cached -> MovieVideo? in
                guard let cachedVideo = cached as? CachedMovieVideo else {
                    return nil
                }
                let movie: MovieVideo? = cachedVideo.map()
                return movie
            }
            observer(.success(movies ?? []))
        }
    }
}

extension MoviesRepository: MoviesRepositoryInterface {
    func retrieveMovies(with category: MoviesCategory?) -> Single<[Movie]> {
        return Single.create(subscribe: { observer in
            guard self.currentNetworkStatus == .reachable else {
                let predicate = NSPredicate(format: "category == '\(category?.rawValue ?? 0)'")
                self.loadLocalMovies(with: predicate, observer: observer)
                return Disposables.create()
            }
            let endpoint = Endpoints.movie(category).path
            let request = self.network.get(endpoint, parameters: ["limit": 100]) { result in
                switch result {
                case let .failure(error):
                    observer(.error(error))
                case let .success(movies):
                    guard let list = self.getList(from: movies) else {
                        observer(.error(MoviesRepositoryErrors.badData))
                        return
                    }
                    self.saveListToDB(category: category, movies: list.results, observer: observer)
                }
            }
            return Disposables.create {
                guard let req = request else { return }
                self.network.cancelNetworkCall(request: req)
            }
        })
    }

    func retrieveMovies(with title: String) -> Single<[Movie]> {
        return Single.create(subscribe: { observer in
            guard self.currentNetworkStatus == .reachable else {
                let predicate = NSPredicate(format: "title BEGINSWITH[cd] '\(title)'")
                self.loadLocalMovies(with: predicate, observer: observer)
                return Disposables.create()
            }
            let endpoint = Endpoints.searchMovies.path
            let params: [String : Any] = ["limit": 100,
                                          "query": title]
            let request = self.network.get(endpoint, parameters: params) { result in
                switch result {
                case let .failure(error):
                    observer(.error(error))
                case let .success(data):
                    guard let list = self.getList(from: data) else {
                        observer(.error(MoviesRepositoryErrors.badData))
                        return
                    }
                    observer(.success(list.results))
                }
            }
            return Disposables.create {
                guard let req = request else { return }
                self.network.cancelNetworkCall(request: req)
            }
        })
    }

    func retrieveMovieVideosWith(id: String) -> Single<[MovieVideo]> {
        return Single.create(subscribe: { observer in
            guard self.currentNetworkStatus == .reachable else {
                let predicate = NSPredicate(format: "id == '\(id)'")
                self.loadLocalMovieVideos(with: predicate, observer: observer)
                return Disposables.create()
            }
            let endpoint = Endpoints.movieVideos(id).path
            let request = self.network.get(endpoint, parameters: nil) { result in
                switch result {
                case let .failure(error):
                    observer(.error(error))
                case let .success(data):
                    do {
                        let videosList = try JSONDecoder().decode(MovieVideoList.self, from: data)
                        self.saveMovieVideosToDB(movieId: id, movieVideos: videosList.videos, observer: observer)
                    } catch let error {
                        observer(.error(error))
                    }
                }
            }
            return Disposables.create {
                guard let req = request else { return }
                self.network.cancelNetworkCall(request: req)
            }
        })
    }

    func subscribeToNetworkChanges() {
        network.subscribeToNetworkStatusChanges()
        .subscribe(onNext: { [weak self] newStatus in
            self?.currentNetworkStatus = newStatus
        })
        .disposed(by: disposeBag)
    }
}
