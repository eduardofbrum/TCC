//
//  CloothingAtLook.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 26/03/24.
//

import Foundation
import Database

class ClothingAtLook {
    var id: UUID
    var position: CGPoint
    var transform: CGAffineTransform
    var look: Look
    var clothing: Clothing
    
    required init(id: UUID = UUID(), position: CGPoint = .zero, transform: CGAffineTransform = .identity, look: Look, clothing: Clothing) {
        self.id = id
        self.position = position
        self.transform = transform
        self.look = look
        self.clothing = clothing
    }
}

extension ClothingAtLook: EntityRepresentable {
    static func decode(representation: Database.EntityRepresentation, visited: inout [UUID : (any Database.EntityRepresentable)?]) -> Self? {
        if let result = visited[representation.id] {
            return (result as? Self)
        }
        
        visited.updateValue(nil, forKey: representation.id)
        
        let jsonDecoder = JSONDecoder()
        
        guard let positionData = representation.values["position"] as? Data,
              let position = try? jsonDecoder.decode(CGPoint.self, from: positionData),
              let transformData = representation.values["transform"] as? Data,
              let transform = try? jsonDecoder.decode(CGAffineTransform.self, from: transformData) else { return nil }
        
        guard let lookRepresentation = representation.toOneRelationships["look"],
              let look = Look.decode(representation: lookRepresentation, visited: &visited),
              let clothingRepresentation = representation.toOneRelationships["clothing"],
              let clothing = Clothing.decode(representation: clothingRepresentation, visited: &visited) else { return nil }
        
        let decoded = Self.init(id: representation.id, position: position, transform: transform, look: look, clothing: clothing)
        visited[representation.id] = decoded

        return decoded
    }
    
    func encode(visited: inout [UUID : Database.EntityRepresentation]) -> Database.EntityRepresentation {
        if let encoded = visited[self.id] {
            return encoded
        }
        
        let encoded = EntityRepresentation(id: self.id, entityName: Models.clothingAtLook.rawValue, values: [:], toOneRelationships: [:], toManyRelationships: [:])
        visited[self.id] = encoded
        
        let jsonEncoder = JSONEncoder()
        
        var values: [String : Any] = [
            "id" : self.id,
        ]
        
        if let position = try? jsonEncoder.encode(self.position) {
            values["position"] = position
        }
        
        if let transform = try? jsonEncoder.encode(self.transform) {
            values["transform"] = transform
        }
        
        let toOneRelationships: [String : EntityRepresentation] = [
            "look" : self.look.encode(visited: &visited),
            "clothing" : self.clothing.encode(visited: &visited)
        ]
        
        let toManyRelationships: [String : [EntityRepresentation]] = [:]
        
        encoded.values = values
        encoded.toOneRelationships = toOneRelationships
        encoded.toManyRelationships = toManyRelationships
        
        return encoded
    }
}
