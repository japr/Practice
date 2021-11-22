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
                    print(movies)
                    observer(.success([]))
                }
            }
            return Disposables.create {
                guard let req = request else { return }
                self.network.cancelNetworkCall(request: req)
            }
        })
    }
}
