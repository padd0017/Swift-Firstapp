//
//  WarehouseRepositoryImpl.swift
//  Inventory
//
//  Created by Vinaydeep Singh Padda on 2025-02-13.
//


import Foundation

struct WarehouseRepositoryImpl: WarehouseRepository {
    let database = Database.shared
    
    //CREATE
    func create(name: String, location: Location, contact: String, manager: String?) async throws -> Warehouse? {
        let newWarehouse = Warehouse(
            id: UUID(),
            name: name,
            location: location,
            contact: contact,
            manager: manager ?? "empty"
        )
        
        await database.addWarehouse(newWarehouse)
        return newWarehouse
    }
    
    
    //GETONE
    func get(id: UUID) async throws -> Warehouse? {
        await database.getWarehouse(id: id)
    }
    
    
    //GETALL
    func list() async throws -> [Warehouse] {
        await database.getAllWarehouses()
    }
    
    
    
    //UPDATE
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
        
        await database.updateWarehouse(at: position, updateWarehouse: updatedWarehouse )
        return updatedWarehouse
        
    }
    
    
    
    //DELETEONE
    func delete(id: UUID) async throws -> Bool {
        guard let position = await Database.shared.warehouses.firstIndex(where:{ $0.id == id}) else {
             return false
          }
        
        await database.deleteOneWarehouse(at: position)
        return true
    }
    
    
    //DELETEALL
    func deleteAll() async throws -> Bool {
        await database.deleteAllWarehouses()
        return true
    }

}
