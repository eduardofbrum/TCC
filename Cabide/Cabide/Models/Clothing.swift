//
//  Clothing.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 25/03/24.
//

import Foundation
import Database

class Clothing: ObservableObject {
    var id: UUID
    
    @Published var image: Data
    @Published var categories: [Category]
    
    var atLooks: [ClothingAtLook]
    
    required init(id: UUID = UUID(), image: Data = Data(), categories: [Category] = [], atLooks: [ClothingAtLook] = []) {
        self.id = id
        self.image = image
        self.categories = categories
        self.atLooks = atLooks
    }
}

extension Clothing: EntityRepresentable {
    static func decode(representation: EntityRepresentation, visited: inout [UUID : (any EntityRepresentable)?]) -> Self? {
        if let result = visited[representation.id] {
            return (result as? Self)
        }
        
        visited.updateValue(nil, forKey: representation.id)
        
        guard let image = representation.values["image"] as? Data,
              let categoriesRepresentation = representation.toManyRelationships["categories"],
              let atLooksRepresentations = representation.toManyRelationships["atLooks"] else { return nil }
        
        let categories = categoriesRepresentation.reduce([Category]()) { partialResult, innerRepresentation in
            guard let model = Category.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let atLooks = atLooksRepresentations.reduce([ClothingAtLook]()) { partialResult, innerRepresentation in
            guard let model = ClothingAtLook.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let decoded = Self.init(id: representation.id, image: image, categories: categories, atLooks: [])
        visited[representation.id] = decoded
        
        return decoded
    }
    
    func encode(visited: inout [UUID : EntityRepresentation]) -> EntityRepresentation {
        if let encoded = visited[self.id] {
            return encoded
        }
        
        let encoded = EntityRepresentation(id: self.id, entityName: Models.clothing.rawValue, values: [:], toOneRelationships: [:], toManyRelationships: [:])
        visited[self.id] = encoded
        
        let values: [String : Any] = [
            "id" : self.id,
            "image" : self.image
        ]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "categories" : self.categories.map({ $0.encode(visited: &visited) }),
            "atLooks" : self.atLooks.map({ $0.encode(visited: &visited) }),
        ]
        
        encoded.values = values
        encoded.toOneRelationships = toOneRelationships
        encoded.toManyRelationships = toManyRelationships
        
        return encoded
    }
}
