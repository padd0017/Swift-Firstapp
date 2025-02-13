//
//  WarehouseRepositoryImpl.swift
//  Inventory
//
//  Created by Vinaydeep Singh Padda on 2025-02-13.
//


import Foundation

struct WarehouseRepositoryImpl: WarehouseRepository {
    
    
    func create(name: String, location: Location, contact: String, manager: String?) async throws -> Warehouse? {
        let newWarehouse = Warehouse(
            id: UUID(),
            name: name,
            location: location,
            contact: contact,
            manager: manager ?? "empty"
        )
        
        await Database.shared.addWarehouse(newWarehouse)
        return newWarehouse
    }
    
    func get(id: UUID) async throws -> Warehouse? {
        await Database.shared.getWarehouse(id: id)
    }
    
    func list() async throws -> [Warehouse] {
        await Database.shared.getAllWarehouses()
    }
    
    func update(id: UUID, name: String, location: Location, contact: String, manager: String?) async throws -> Warehouse? {
        guard let position = await Database.shared.warehouses.firstIndex(where: {
            $0.id == id
        }) else {
            return nil
        }
        
        let updatedWarehouse = Warehouse(
            id: id,
            name: name,
            location: location,
            contact: contact,
            manager: manager ?? "empty"
        )
        
        await Database.shared.updateWarehouse(at: position, updateWarehouse: updatedWarehouse )
        return updatedWarehouse
        
    }
    
    
    func delete(id: UUID) async throws -> Bool {
        guard let position = await Database.shared.warehouses.firstIndex(where:{ $0.id == id}) else {
             return false
          }
        
        await Database.shared.deleteOneWarehouse(at: position)
        return true
    }
    

}
