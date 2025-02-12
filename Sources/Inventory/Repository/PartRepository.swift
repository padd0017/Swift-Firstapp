//
//  PartRepository.swift
//  Inventory
//
//  Created by Mohamed El-Halawani on 2025-02-01.
//

import Foundation

protocol PartRepository: Sendable {
    
    func create(name: String, category: PartCategory, size: Dimensions?, weight: Double?) async throws -> Part?
    
    func get(id: UUID) async throws -> Part?
    
    func list() async throws -> [Part]
    
    func update(id: UUID, name: String, category: PartCategory, size: Dimensions?, weight: Double?) async throws -> Part?
    
    func delete(id: UUID) async throws -> Bool
    
    func deleteAll() async throws -> Bool
}


