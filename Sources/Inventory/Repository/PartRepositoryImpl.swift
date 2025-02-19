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
        await Database.shared.add(element: newPart)
//        await Database.shared.parts.append(newPart)
        return newPart
    }
    
    //GET BY ID
    func get(id: UUID) async throws -> Part? {
      return await Database.shared.get(id: id)
    }
    
    //GET ALL
    func list() async throws -> [Part] {
        return await Database.shared.list()
    }
    
    //UPDATE
    func update(id: UUID, name: String, category: PartCategory, size: Dimensions?, weight: Double?) async throws -> Part? {
        
        let updatedPart = Part(
            id: id,
            name: name,
            category: category,
            size: size ?? Dimensions(height: 0, width: 0, length: 0),
            weight: weight ?? 0
        )
        let success = await Database.shared.update(element: updatedPart)
                return success ? updatedPart : nil
    }
    
    //DELETE BY ID
    
    func delete(id: UUID) async throws -> Bool {
        return await Database.shared.delete(id: id)
    
    }
    
    //DELETE ALL
    
    func deleteAll() async throws -> Bool {
        await Database.shared.deleteAll()
        return true
    }
    
}
