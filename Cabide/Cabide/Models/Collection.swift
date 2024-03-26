//
//  Collection.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 26/03/24.
//

import Foundation
import Database

class Collection {
    var id: UUID
    var name: String
    var looks: [Look]
    
    required init(id: UUID = UUID(), name: String = "Default", looks: [Look] = []) {
        self.id = id
        self.name = name
        self.looks = looks
    }
}

extension Collection: EntityRepresentable {
    static func decode(representation: Database.EntityRepresentation, visited: inout [UUID : (any Database.EntityRepresentable)?]) -> Self? {
        guard let name = representation.values["name"] as? String,
              let looksRepresentations = representation.toManyRelationships["looks"] else { return nil }
        
        let looks = looksRepresentations.reduce([Look]()) { partialResult, innerRepresentation in
            guard let model = Look.decode(representation: innerRepresentation, visited: &visited) else { return partialResult }
            
            var result = partialResult
            result.append(model)
            
            return result
        }
        
        let decoded = Self.init(id: representation.id, name: name, looks: looks)
        visited[representation.id] = decoded
        
        return decoded
    }
    
    func encode(visited: inout [UUID : Database.EntityRepresentation]) -> Database.EntityRepresentation {
        if let encoded = visited[self.id] {
            return encoded
        }
        
        let encoded = EntityRepresentation(id: self.id, entityName: Models.collection.rawValue, values: [:], toOneRelationships: [:], toManyRelationships: [:])
        visited[self.id] = encoded
        
        let values: [String : Any] = [
            "id" : self.id,
            "name" : self.name
        ]
        
        let toOneRelationships: [String : EntityRepresentation] = [:]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [
            "looks" : self.looks.map({ $0.encode(visited: &visited) }),
        ]
        
        encoded.values = values
        encoded.toOneRelationships = toOneRelationships
        encoded.toManyRelationships = toManyRelationships
        
        return encoded
    }
}
