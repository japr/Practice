//
//  Movie.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation

struct Movie {
    let id: Int64
    let overview: String
    let posterPath: String
    let title: String
    let videoAvailable: Bool
    let votesAverage: Double
}

extension Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case overview
        case posterPath = "poster_path"
        case title
        case videoAvailable = "video"
        case votesAverage = "vote_average"
    }
}
