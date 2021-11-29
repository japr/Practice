//
//  CachedMovieVideos.swift
//  Practice
//
//  Created by Jorge Palacio on 11/29/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import CoreData

class CachedMovieVideo: NSManagedObject {
    @NSManaged public var id: String?
    @NSManaged public var key: String?
    @NSManaged public var name: String?
    @NSManaged public var site: String?
    @NSManaged public var type: String?

    func update(from movie: MovieVideo) {
        id = movie.id
        key = movie.key
        name = movie.name
        site = movie.site
        type = movie.type
    }
}

extension CachedMovieVideo: DatabaseEntity {

    typealias DbType = CachedMovieVideo

    static var entityName: String {
        return String(describing: self)
    }

    func map<T: Codable>() -> T? {
        let movie = MovieVideo(id: id ?? "",
                               key: key ?? "",
                               name: name ?? "",
                               site: site ?? "",
                               type: type ?? "")

        guard let generic = movie as? T else {
            return nil
        }
        return generic
    }
}
