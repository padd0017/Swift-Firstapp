//
//  Database.swift
//  Inventory
//
//  Created by Vinaydeep Singh Padda on 2025-02-12.
//

import Foundation


actor Database {
    var parts: [Part] = []
    var warehouse: [WareHouse] = []
    
    static let shared = Database()
    private init() {}
    
    
    
    
    
    func addPart(_ part: Part) {
        parts.append(part)
    }
    
    func getPart(id: UUID) -> Part? {
        parts.first{part in
            part.id == id
        }
    }
    
    func getAllParts() -> [Part] {
        parts
    }
    
    
    func updatePart(id: UUID, updatePart: Part) -> Part? {
        guard let position = parts.firstIndex(where: {
            $0.id == id
        }) else {
            return nil
        }
     parts[position] = updatePart
        return updatePart
    }
}
