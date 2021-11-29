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
        guard site.lowercased() == "youtube" else { return nil }
        let fullPath = "https://www.youtube.com/embed/\(key)"
        return URL(string: fullPath)
    }

    func getVimeoURL() -> URL? {
        guard site.lowercased() == "vimeo" else { return nil }
        let fullPath = "https://player.vimeo.com/video/\(key)"
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

