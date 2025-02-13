//
//  PartRepositoryImpl.swift
//  Inventory
//
//  Created by Vinaydeep Singh Padda on 2025-02-12.
//

import Foundation

struct PartRepositoryImpl: PartRepository {
    let database = Database.shared
    
    //CREATE
    func create(name: String, category: PartCategory, size: Dimensions?, weight: Double?) async throws -> Part? {
        let newPart = Part(
            id: UUID(),
            name: name,
            category: category,
            size: size ?? Dimensions(height: 0, width: 0, length: 0),
            weight: weight ?? 0
            )
       await database.addPart(newPart)
//        await Database.shared.parts.append(newPart)
        return newPart
    }
    
    //GET BY ID
    func get(id: UUID) async throws -> Part? {
        await database.getPart(id: id)
    }
    
    //GET ALL
    func list() async throws -> [Part] {
        await database.getAllParts()
    }
    
    //UPDATE
    func update(id: UUID, name: String, category: PartCategory, size: Dimensions?, weight: Double?) async throws -> Part? {
       guard let position = await Database.shared.parts.firstIndex(where: {
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
        await database.updatePart(at: position, updatePart: updatedPart)
        return updatedPart
    }
    
    //DELETE BY ID
    
    func delete(id: UUID) async throws -> Bool {
      guard let position = await Database.shared.parts.firstIndex(where:{ $0.id == id}) else {
           return false
        }
        
        await database.deletePart(at: position)
        return true
    }
    
    //DELETE ALL
    
    func deleteAll() async throws -> Bool {
        await database.deleteAllParts()
        return true
    }
    
}
