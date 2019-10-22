//
//  DatabaseEntity.swift
//  Practice
//
//  Created by Jorge Palacio on 10/20/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import CoreData
import Foundation

protocol DatabaseEntity {
    associatedtype DbType: NSFetchRequestResult
    static var entityName: String { get }
    static var primaryKeyAttributeName: String { get }
    func map<T: Codable>() -> T?
}

extension DatabaseEntity {
    static var primaryKeyAttributeName: String {
        return "id"
    }
}
