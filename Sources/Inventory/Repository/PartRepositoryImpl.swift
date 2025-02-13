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
    
    
    func get(id: UUID) async throws -> Part? {
        await Database.shared.getPart(id: id)
    }
    
    func list() async throws -> [Part] {
        await Database.shared.getAllParts()
    }
    
    
    func update(id: UUID, name: String, category: PartCategory, size: Dimensions?, weight: Double?) async throws -> Part? {
        let updatedPart = Part(
            id: id,
            name: name,
            category: category,
            size: size ?? Dimensions(height: 0, width: 0, length: 0),
            weight: weight ?? 0
        )
        return await Database.shared.updatePart(id: id, updatePart: updatedPart)
    }
}
