//
//  CachedMovies.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import CoreData

class CachedMovie: NSManagedObject {
    @NSManaged public var category: Int32
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var overview: String?
    @NSManaged public var videoAvailable: Bool
    @NSManaged public var id: Int64
    @NSManaged public var posterPath: String?

    func update(from movie: Movie, and cat: MoviesCategory) {
        title = movie.title
        voteAverage = movie.votesAverage
        overview = movie.overview
        videoAvailable = movie.videoAvailable
        id = movie.id
        posterPath = movie.posterPath
        category = Int32(cat.rawValue)
    }
}

extension CachedMovie: DatabaseEntity {
    typealias DbType = CachedMovie

    static var entityName: String {
        return String(describing: self)
    }

    func map<T: Codable>() -> T? {
        let movie = Movie(id: id,
                          overview: overview ?? "",
                          posterPath: posterPath ?? "",
                          title: title ?? "",
                          videoAvailable: videoAvailable,
                          votesAverage: voteAverage)

        guard let generic = movie as? T else {
            return nil
        }
        return generic
    }
}
