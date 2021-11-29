//
//  DatabaseEntity.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
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
