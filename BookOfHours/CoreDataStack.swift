//
//  CoreDataStack.swift
//  BookOfHours
//
//  Created by Gabriel Getzie on 8/21/25.
//

import Foundation
import CoreData

public class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
            return container
        }()
    private init() { }
}

