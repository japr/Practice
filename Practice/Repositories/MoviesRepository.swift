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
}

enum MoviesCategory: Int {
    case popular
    case topRated
    case upcoming
}

enum MoviesRepositoryErrors: Error {
    case badData
}

class MoviesRepository {

    private let database: Database
    private let network: NetworkConnection

    init(database: Database = .default, network: NetworkConnection = .default) {
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
}

extension MoviesRepository: MoviesRepositoryInterface {
    func retrieveMovies(with category: MoviesCategory?) -> Single<[Movie]> {
        return Single.create(subscribe: { observer in
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
}
