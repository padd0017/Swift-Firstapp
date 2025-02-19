//
//  WarehouseRepositoryImpl.swift
//  Inventory
//
//  Created by Vinaydeep Singh Padda on 2025-02-13.
//


import Foundation

struct WarehouseRepositoryImpl: WarehouseRepository {
    //CREATE
    func create(name: String, location: Location, contact: String, manager: String?) async throws -> Warehouse? {
        let newWarehouse = Warehouse(
            id: UUID(),
            name: name,
            location: location,
            contact: contact,
            manager: manager
        )
        
        await Database.shared.add(element: newWarehouse)
        return newWarehouse
    }
    
    
    //GETONE
    func get(id: UUID) async throws -> Warehouse? {
        return await Database.shared.get(id: id)
    }
    
    
    //GETALL
    func list() async throws -> [Warehouse] {
        return await Database.shared.getAll()
    }
    
    
    
    //UPDATE
    func update(id: UUID, name: String, location: Location, contact: String, manager: String?) async throws -> Warehouse? {
        let updatedWarehouse = Warehouse(
            id: id,
            name: name,
            location: location,
            contact: contact,
            manager: manager 
        )
        
        let success = await Database.shared.update(id: id, newWarehouse: updatedWarehouse)
        return success ? updatedWarehouse : nil
    }
    
    
    
    //DELETEONE
    func delete(id: UUID) async throws -> Bool {
        
        return await Database.shared.deleteOne(id: id)
    }
    
    
    //DELETEALL
    func deleteAll() async throws -> Bool {
        await Database.shared.deleteAllWarehouse()
        return true
    }

}
