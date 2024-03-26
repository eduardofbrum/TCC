//
//  Dependencies.swift
//  DependencyInjection
//
//  Created by Gabriel Medeiros Martins on 25/03/24.
//

import Foundation

public final class Dependencies {
    private static var storage: [ObjectIdentifier : Any] = [:]
    
    public static func register<T>(_ object: Any, for type: T.Type) {
        guard object is T else {
            fatalError("ERROR: \(object) is not a subtype of \(T.self), or does not conform to \(type)")
        }
        
        let id = ObjectIdentifier(type)
        
        if let injectedObject = storage[id] {
            print("WARNING: \(type) already has object \(injectedObject) registered; overwritting with \(object)")
        }
        
        storage[id] = object
    }
    
    public static func resolve<T>(for type: T.Type) -> T {
        let id = ObjectIdentifier(type)
        
        guard let injectedObject = storage[id] as? T else {
            fatalError("ERROR: no objects registered for \(type)")
        }
        
        return injectedObject
    }
}
