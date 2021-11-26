//
//  MovieVideo.swift
//  Practice
//
//  Created by Jorge Palacio on 11/26/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation

struct MovieVideo {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String

    func getYoutubeURL() -> URL? {
        guard site == "Youtube" else { return nil }
        let fullPath = "https://www.youtube.com/watch?v=\(key)"
        return URL(string: fullPath)
    }

    func getVimeoURL() -> URL? {
        guard site == "Vimeo" else { return nil }
        let fullPath = "https://vimeo.com/\(key)"
        return URL(string: fullPath)
    }
}

extension MovieVideo: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case key
        case name
        case site
        case type
    }
}

