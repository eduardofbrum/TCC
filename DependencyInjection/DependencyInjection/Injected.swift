//
//  DependencyInjection.swift
//  DependencyInjection
//
//  Created by Gabriel Medeiros Martins on 25/03/24.
//

import Foundation

@propertyWrapper
public struct Injected<Service> {
    
    private let type: Service.Type
    
    public init(_ type: Service.Type = Service.self) {
        self.type = type
    }
    
    public var wrappedValue: Service {
        Dependencies.resolve(for: Service.self)
    }
}
