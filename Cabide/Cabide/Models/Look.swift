//
//  Look.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 26/03/24.
//

import Foundation
import Database

class Look {
    var id: UUID
    var name: String
    var thumbnail: Data
    
    var clothes: [ClothingAtLook]
    
    required init(id: UUID = UUID(), name: String = "Default", thumbnail: Data, clothes: [ClothingAtLook] = []) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.clothes = clothes
    }
}

extension Look: EntityRepresentable {
    static func decode(representation: Database.EntityRepresentation, visited: inout [UUID : (any Database.EntityRepresentable)?]) -> Self? {
        if let result = visited[representation.id] {
            return (result as? Self)
        }
        
        visited.updateValue(nil, forKey: representation.id)
        
        guard let name = representation.values["name"] as? String,
              let thumbnail = representation.values["thumbnail"] as? Data,
              let clothesRepresentations = representation.toManyRelationships["clothes"]  else { return nil }
        
        let clothes = clothesRepresentations.reduce([ClothingAtLook]()) { partialResult, innerRepresentation in
            guard let model = ClothingAtLook.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let decoded = Self.init(id: representation.id, name: name, thumbnail: thumbnail, clothes: clothes)
        visited[representation.id] = decoded
        
        return decoded
    }

    func encode(visited: inout [UUID : Database.EntityRepresentation]) -> Database.EntityRepresentation {
        if let encoded = visited[self.id] {
            return encoded
        }
        
        let encoded = EntityRepresentation(id: self.id, entityName: Models.look.rawValue, values: [:], toOneRelationships: [:], toManyRelationships: [:])
        visited[self.id] = encoded
        
        let values: [String : Any] = [
            "id" : self.id,
            "name" : self.name,
            "thumbnail" : self.thumbnail
        ]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "clothes" : self.clothes.map({ $0.encode(visited: &visited) })
        ]
        
        encoded.values = values
        encoded.toOneRelationships = toOneRelationships
        encoded.toManyRelationships = toManyRelationships
        
        return encoded
    }   
}
