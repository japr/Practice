//
//  API.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation

protocol EnvironmentPath {
    var path: String { get }
}

enum Environment {
    case dev
}

extension Environment: EnvironmentPath {
    var path: String {
        switch self {
        case .dev:  return "https://api.themoviedb.org/4"
        }
    }
}

protocol EndpointPath {
    var path: String { get }
}

enum Endpoints {
    case list(_ listId: Int)
}

extension Endpoints: EndpointPath {
    var path: String {
        switch self {
        case .list(let id): return "/list/\(id)"
        }
    }
}
