//
//  NetworkManagerTests.swift
//  PracticeTests
//
//  Created by Jorge Palacio on 11/29/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import XCTest
@testable import Practice

class NetworkManagerTests: XCTestCase {

    let bearerToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjOWZmMmYwNDg0ZmYzZmNlNzg2YzlhMTIwOWI1NzMwMCIsInN1YiI6IjVkYTNjMjIxMTk2NzU3MDAxM2FiY2VlNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FNJ0sic0I7yIbB_8AXB-oGGGe_Lwo0lleZLAvq36b1E"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testDefaultHeaders() {
        let connection = NetworkConnection()
        let dataRequest = connection.get(Endpoints.movie(.popular).path) { _ in }
        let headers = dataRequest?.request?.allHTTPHeaderFields
        XCTAssertEqual(headers?["Accept"], "application/json", "Values should be the same")
        XCTAssertEqual(headers?["Authorization"], bearerToken, "Values should be the same")
    }

    func testDefaultDevEnvironment() {
        let connection = NetworkConnection()
        let dataRequest = connection.get(Endpoints.movie(.popular).path) { _ in }
        let baseURL = dataRequest?.request?.url?.absoluteString ?? ""
        XCTAssertNotNil(baseURL, "Base url should not be nil")
        let urlTest = Environment.dev.path+Endpoints.movie(.popular).path
        XCTAssertEqual(baseURL, urlTest, "Dev path should be selected by default")
    }
}
