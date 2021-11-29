//
//  NetworkManagerMock.swift
//  PracticeTests
//
//  Created by Jorge Palacio on 11/29/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import XCTest
import Alamofire
import RxSwift
@testable import Practice

class NetworkConnectionMock: NetworkInferface {

    private var currentStatus = BehaviorSubject<NetworkStatus>(value: .reachable)

    func swithNetworkStatus() {
        do {
            let status: NetworkStatus = try currentStatus.value() == .reachable ? .notReachable : .reachable
            currentStatus.onNext(status)
        } catch _  {
            currentStatus.onNext(.notReachable)
        }
    }

    func cancelNetworkCall(request: DataRequest) {}

    func get(_ path: String, parameters: [String : Any]?, _ callback: @escaping ResponseDataCallback) -> DataRequest? {
        return Alamofire.request(path,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: nil)
    }

    func getImage(_ path: String, _ callback: @escaping ResponseDataCallback) -> DataRequest? {
        return Alamofire.request(path,
                                 method: .get,
                                 encoding: URLEncoding.default,
                                 headers: nil)
    }

    func subscribeToNetworkStatusChanges() -> Observable<NetworkStatus> {
        return currentStatus
    }
}
