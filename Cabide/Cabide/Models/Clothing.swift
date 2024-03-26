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
    
    required init(id: UUID = UUID(), image: Data = Data()) {
        self.id = id
        self.image = image
    }
}

extension Clothing: EntityRepresentable {
    static func decode(representation: EntityRepresentation, visited: inout [UUID : (any EntityRepresentable)?]) -> Self? {
        if let result = visited[representation.id] {
            return (result as? Self)
        }
        
        visited.updateValue(nil, forKey: representation.id)
        
        guard let image = representation.values["image"] as? Data else { return nil }
        
        let decoded = Self.init(id: representation.id, image: image)
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
        
        let toManyRelationships: [String : [EntityRepresentation]] = [:]
        
        encoded.values = values
        encoded.toOneRelationships = toOneRelationships
        encoded.toManyRelationships = toManyRelationships
        
        return encoded
    }
}
