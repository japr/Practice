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
    case images
}

extension Environment: EnvironmentPath {
    var path: String {
        switch self {
        case .dev:  return "https://api.themoviedb.org/3"
        case .images: return "https://image.tmdb.org/t/p/w300"
        }
    }
}

protocol EndpointPath {
    var path: String { get }
}

enum Endpoints {
    case list(_ listId: Int)
    case movie(_ category: MoviesCategory?)
    case movieVideos(_ movieId: String)
    case searchMovies
}

extension Endpoints: EndpointPath {
    var path: String {
        switch self {
        case .list(let id): return "/list/\(id)"
        case .movie(let cat):
            switch cat {
            case .popular: return "/movie/popular"
            case .topRated: return "/movie/top_rated"
            case .upcoming: return "/movie/upcoming"
            default: return "/movie/"
            }
        case .movieVideos(let id): return "/movie/\(id)/videos"
        case .searchMovies: return "/search/movie"
        }
    }
}
