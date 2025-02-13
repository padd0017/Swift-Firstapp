//
//  Database.swift
//  Inventory
//
//  Created by Vinaydeep Singh Padda on 2025-02-12.
//

import Foundation


actor Database {
    var parts: [Part] = []
    var warehouses: [Warehouse] = []
    
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
    
    
    func updatePart(at position : Int, updatePart: Part) {
      parts[position] = updatePart
    }
    
    
    func deletePart(at position: Int) {
        parts.remove(at: position)
    }
    
    func deleteAllParts() {
        parts.removeAll()
    }
    
    
    
    //WAREHOUSE
    
    
    func addWarehouse(_ warehouse: Warehouse) {
        warehouses.append(warehouse)
    }
    
    func getWarehouse(id: UUID) -> Warehouse? {
        warehouses.first{warehouse in
            warehouse.id == id
        }
    }
    
    
    func getAllWarehouses() -> [Warehouse] {
        warehouses
    }
    
    
    func updateWarehouse(at position: Int, updateWarehouse: Warehouse) {
        warehouses[position] = updateWarehouse
    }
    
    
    func deleteOneWarehouse(at position: Int) {
        warehouses.remove(at: position)
    }
    
    
    func deleteAllWarehouses() {
        warehouses.removeAll()
    }
    
}
