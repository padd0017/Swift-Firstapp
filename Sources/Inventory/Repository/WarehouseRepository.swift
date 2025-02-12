//
//  Warehouse.swift
//  Inventory
//
//  Created by Mohamed El-Halawani on 2025-02-01.
//

import Foundation

protocol WarehouseRepository: Sendable {
    func create(name: String, location: Location, contact: String, manager: String?) async throws -> Warehouse?
    
    func get(id: UUID) async throws -> Warehouse?
    
    func list() async throws -> [Warehouse]
    
    func update(id: UUID, name: String, location: Location, contact: String, manager: String?) async throws -> Warehouse?
    
    func delete(id: UUID) async throws -> Bool
    
    func deleteAll() async throws -> Bool
}
