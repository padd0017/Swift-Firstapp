//
//  PartRepositoryImpl.swift
//  Inventory
//
//  Created by Vinaydeep Singh Padda on 2025-02-12.
//

import Foundation

struct PartRepositoryImpl: PartRepository {
    //CREATE
    func create(name: String, category: PartCategory, size: Dimensions?, weight: Double?) async throws -> Part? {
        let newPart = Part(
            id: UUID(),
            name: name,
            category: category,
            size: size ?? Dimensions(height: 0, width: 0, length: 0),
            weight: weight ?? 0
            )
       await Database.shared.addPart(newPart)
//        await Database.shared.parts.append(newPart)
        return newPart
    }
    
    //GET BY ID
    func get(id: UUID) async throws -> Part? {
        await Database.shared.getPart(id: id)
    }
    
    //GET ALL
    func list() async throws -> [Part] {
        await Database.shared.getAllParts()
    }
    
    //UPDATE
    func update(id: UUID, name: String, category: PartCategory, size: Dimensions?, weight: Double?) async throws -> Part? {
        guard let position = Database.shared.parts.firstIndex(where: {
            $0.id == id
        }) else {
            return nil
        }

        
        let updatedPart = Part(
            id: id,
            name: name,
            category: category,
            size: size ?? Dimensions(height: 0, width: 0, length: 0),
            weight: weight ?? 0
        )
         await Database.shared.updatePart(at: position with updatedPart)
        return updatedPart
    }
    
    //DELETE BY ID
    
    func delete(id: UUID) async throws -> Bool {
        guard let position = Database.shared.parts.firstIndex(where:{ $0.id == id}) else {
           return false
        }
        
        await Database.shared.deletePart(at: position)
        return true
    }
    
    //DELETE ALL
    
}
