//
//  NetworkManager.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Alamofire

enum NetworkError: Error {
    case badURL
}

typealias ResponseDataCallback = (Swift.Result<Data, Error>) -> Void

protocol NetworkInferface {
    func cancelNetworkCall(request: Alamofire.DataRequest)
    func get(_ path: String, parameters: [String: Any]?, _ callback: @escaping ResponseDataCallback) -> Alamofire.DataRequest?
}

class NetworkConnection {

    private let environment: Environment
    private let sessionManager: Alamofire.SessionManager
    private var activeRequests: [Alamofire.DataRequest] = []

    static let `default` = NetworkConnection()

    private lazy var defaultHTTPHeaders: Alamofire.HTTPHeaders = {
        var defaultHTTPHeaders = SessionManager.defaultHTTPHeaders
        defaultHTTPHeaders["Accept"] = "application/json"
        defaultHTTPHeaders["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1YmFlNGI4MTNmMDNjYWU1MTUzODA4ODBiY2Q3NjAwZiIsInN1YiI6IjYxYTUyMTE2M2UyZWM4MDAyOTk2NWQwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.6bAtW_wBg0fMtkb9qPKykipYQDgPbnxRl_-1UZNU2Is"
        return defaultHTTPHeaders
    }()

    init(environment: Environment = .dev) {
        self.environment = environment
        let configuration = URLSessionConfiguration.default
        configuration.multipathServiceType = .handover
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
}

extension NetworkConnection: NetworkInferface {
    func cancelNetworkCall(request: Alamofire.DataRequest) {
        request.cancel()
    }

    func get(_ path: String, parameters: [String: Any]? = nil, _ callback: @escaping ResponseDataCallback) -> Alamofire.DataRequest? {
        guard let url = URL(string: environment.path + path) else {
            callback(.failure(NetworkError.badURL))
            return nil
        }
        let request = sessionManager
            .request(
                url,
                method: Alamofire.HTTPMethod.get,
                parameters: parameters,
                encoding: Alamofire.URLEncoding.default,
                headers: defaultHTTPHeaders
        ).responseData { (response) in
            switch response.result {
            case let .failure(error): callback(.failure(error))
            case let .success(value): callback(.success(value))
            }
        }
        activeRequests.append(request)
        return request
    }
}
