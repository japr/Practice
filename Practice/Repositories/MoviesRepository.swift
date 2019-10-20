//
//  MoviesRepository.swift
//  Practice
//
//  Created by Jorge Palacio on 10/20/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import Combine

protocol MoviesRepositoryInterface {
    func retrieveMovies() -> [Movie]
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
    func retrieveMovies() -> [Movie] {
        return []
    }
}
