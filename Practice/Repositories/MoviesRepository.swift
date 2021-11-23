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
    func retrieveMovies() -> Single<[Movie]>
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
}

extension MoviesRepository: MoviesRepositoryInterface {
    func retrieveMovies() -> Single<[Movie]> {
        return Single.create(subscribe: { observer in
            let request = self.network.get(Endpoints.list(1).path, parameters: ["limit": 100]) { result in
                switch result {
                case let .failure(error):
                    observer(.error(error))
                case let .success(movies):
                    do {
                        let context = Database.temporaryContext()
                        let list = try JSONDecoder().decode(List.self, from: movies)
                        Database.sharedQueue.async {
                            let entities = list.results.compactMap { [weak self] movie -> CachedMovie? in
                                guard let strongSelf = self else { return nil }

                                do {
                                    let cachedMovie: CachedMovie = try strongSelf.database.insertNewEntity(in: context)
                                    cachedMovie.update(from: movie)
                                    return cachedMovie
                                } catch _ { return nil }
                            }
                            self.database.save(entities, in: context) { (error) in
                                guard let error = error else {
                                    observer(.success(list.results))
                                    return
                                }
                                observer(.error(error))
                            }
                        }
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
}
