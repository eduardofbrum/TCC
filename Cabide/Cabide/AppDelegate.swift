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
        
        return true
    }
}
