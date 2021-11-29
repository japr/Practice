//
//  MoviesRepositoryTests.swift
//  PracticeTests
//
//  Created by Jorge Palacio on 11/29/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import XCTest
@testable import Practice

class MoviesRepositoryTests: XCTestCase {

    func testRepositoryInitializationWithDefaultValues() {
        let repository = MoviesRepository()
        XCTAssertNotNil(repository, "Repository should not be nil")
    }

    func testRepositoryInitializationWithMockeValue() {
        let repository = MoviesRepository(database: Database(),
                                          network: NetworkConnectionMock())
        XCTAssertNotNil(repository, "Repository should not be nil")
    }

    func testRepositoryNetworkChanges() {
        let networkMock = NetworkConnectionMock()
        let repository = MoviesRepository(database: Database(),
                                          network: networkMock)
        repository.subscribeToNetworkChanges()
        XCTAssertEqual(repository.currentNetworkStatus, NetworkStatus.reachable)
        networkMock.swithNetworkStatus()
        XCTAssertEqual(repository.currentNetworkStatus, NetworkStatus.notReachable)
    }
}
