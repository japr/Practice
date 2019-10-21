//
//  MovieVideoList.swift
//  Practice
//
//  Created by Jorge Palacio on 10/21/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation

struct MovieVideoList {
    let id: Int64
    let videos: [MovieVideo]
}

extension MovieVideoList: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case videos = "results"
    }
}
