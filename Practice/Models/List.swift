//
//  List.swift
//  Practice
//
//  Created by Jorge Palacio on 11/23/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation

struct List {
    let page: Int
    let results: [Movie]
    let totalPages: Int
}

extension List: Codable {
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}
