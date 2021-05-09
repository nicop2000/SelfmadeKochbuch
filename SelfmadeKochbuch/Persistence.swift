//
//  Persistence.swift
//  Selfmade Kochbuch
//
//  Created by Nico Petersen on 01.03.21.
//


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    

    let container: NSPersistentCloudKitContainer

    init() {
        container = NSPersistentCloudKitContainer(name: "SelfmadeKochbuch")
        

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
