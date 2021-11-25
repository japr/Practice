//
//  Database.swift
//  Practice
//
//  Created by Jorge Palacio on 11/22/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import CoreData

typealias DbTransactionCallback = (Error?) -> Void

class Database {

    private var persistentContainer: NSPersistentContainer

    static let sharedQueue = DispatchQueue(label: "com.database.queue")

    static let `default` = Database()

    init(persistentContainer: NSPersistentContainer = createPersistentContainer()) {
        self.persistentContainer = persistentContainer
    }

    static func createPersistentContainer() -> NSPersistentContainer {

        guard var storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }

        storeURL = storeURL.appendingPathComponent("store.sqlite")
        let modelURL = Bundle(for: Database.self).url(forResource: "Practice", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let persistentStoreDescription = NSPersistentStoreDescription(url: storeURL)
        let persistentContainer = NSPersistentContainer(name: "Practice", managedObjectModel: model)
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        persistentContainer.loadPersistentStores { _, error in
            guard let error = error else { return }

            fatalError("\(error)")
        }

        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return persistentContainer
    }

    static func temporaryContext() -> NSManagedObjectContext {
        let context = Database.default.persistentContainer.newBackgroundContext()
        return context
    }

    func reset() {
        persistentContainer.viewContext.reset()
        persistentContainer = Database.createPersistentContainer()
    }

    func insertNewEntity<T: DatabaseEntity>(in context: NSManagedObjectContext) throws -> T {
        guard let nEntity = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: context) as? T else {
            throw NSError(domain: "com.practice.database", code: 1, userInfo: nil)
        }
        return nEntity
    }

    func save<T: DatabaseEntity>(_ entities: [T], in context: NSManagedObjectContext, callback: DbTransactionCallback?) {
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.perform {
            do {
                try context.save()
                callback?(nil)
            } catch {
                let error = NSError(domain: "database.update()", code: 1, userInfo: nil)
                callback?(error)
            }
        }
    }
}

