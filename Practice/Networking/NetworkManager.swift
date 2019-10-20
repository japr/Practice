//
//  NetworkManager.swift
//  Practice
//
//  Created by Jorge Palacio on 10/20/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import Alamofire

enum NetworkError: Error {
    case badURL
}

class NetworkConnection {

    typealias ResponseJSONCallback = (Swift.Result<Any, Error>) -> Void

    private let environment: Environment
    private let sessionManager: Alamofire.SessionManager

    static let `default` = NetworkConnection()

    private lazy var defaultHTTPHeaders: Alamofire.HTTPHeaders = {
        var defaultHTTPHeaders = SessionManager.defaultHTTPHeaders
        defaultHTTPHeaders["Accept"] = "application/json"
        defaultHTTPHeaders["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjOWZmMmYwNDg0ZmYzZmNlNzg2YzlhMTIwOWI1NzMwMCIsInN1YiI6IjVkYTNjMjIxMTk2NzU3MDAxM2FiY2VlNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.FNJ0sic0I7yIbB_8AXB-oGGGe_Lwo0lleZLAvq36b1E"
        return defaultHTTPHeaders
    }()

    init(environment: Environment = .dev) {
        self.environment = environment
        let configuration = URLSessionConfiguration.default
        configuration.multipathServiceType = .handover
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }

    func get(_ path: String, parameters: [String: Any]? = nil, _ callback: @escaping ResponseJSONCallback) {
        guard let url = URL(string: environment.path + path) else {
            callback(.failure(NetworkError.badURL))
            return
        }
        sessionManager
            .request(
                url,
                method: Alamofire.HTTPMethod.get,
                parameters: parameters,
                encoding: Alamofire.JSONEncoding.default,
                headers: defaultHTTPHeaders
        ).responseJSON { (response) in
            switch response.result {
            case let .failure(error): callback(.failure(error))
            case let .success(value): callback(.success(value))
            }
        }
    }
}
