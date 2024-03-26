//
//  AppDelegate.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 25/03/24.
//

import Foundation
import UIKit
import DependencyInjection
import Database

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Dependencies.register(CoreDataRepository<Clothing>(container: PersistenceController.shared.container, entityName: Models.clothing.rawValue), for: (any Repository<Clothing>).self)
        Dependencies.register(CoreDataRepository<Category>(container: PersistenceController.shared.container, entityName: Models.category.rawValue), for: (any Repository<Category>).self)
        Dependencies.register(CoreDataRepository<Look>(container: PersistenceController.shared.container, entityName: Models.look.rawValue), for: (any Repository<Look>).self)
        Dependencies.register(CoreDataRepository<ClothingAtLook>(container: PersistenceController.shared.container, entityName: Models.clothingAtLook.rawValue), for: (any Repository<ClothingAtLook>).self)
        Dependencies.register(CoreDataRepository<Collection>(container: PersistenceController.shared.container, entityName: Models.collection.rawValue), for: (any Repository<Collection>).self)
        
        return true
    }
}
