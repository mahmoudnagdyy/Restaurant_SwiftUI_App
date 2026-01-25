//
//  CoreDataManager.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 25/01/2026.
//

import Foundation
import CoreData


class CoreDataManager {
    
    static let instance = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "Restaurant")
        container.loadPersistentStores { description, error in
            if let error {
                print("Error loading Core Data stack: \(error.localizedDescription) ")
            }
        }
        context = container.viewContext
    }
    
}
