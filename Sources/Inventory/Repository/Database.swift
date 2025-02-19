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
    
    
    
    
    
    func add(element: Part) async {
        parts.append(element)
    }
    
    func get(id: UUID) -> Part? {
        parts.first{part in
            part.id == id
        }
    }
    
    func list() -> [Part] {
        parts
    }
    
    
    func update(element: Part) async -> Bool {
           guard let index = parts.firstIndex(where: { $0.id == element.id }) else {
               return false
           }
           parts[index] = element
           return true
       }
    
    
    func delete(id: UUID) async -> Bool {
            guard let index = parts.firstIndex(where: { $0.id == id }) else {
                return false
            }
            parts.remove(at: index)
            return true
        }

    func deleteAll() async {
        parts.removeAll()
    }
    
    
    
    //WAREHOUSE
    
    
    func add(element: Warehouse) async {
        warehouses.append(element)
    }
    
    func get(id: UUID) async -> Warehouse? {
       return warehouses.first{warehouse in
            warehouse.id == id
        }
    }
    
    
    func getAll() async -> [Warehouse] {
        return warehouses
    }
    
    
    func update(id: UUID, newWarehouse: Warehouse) async -> Bool {
        guard let index = warehouses.firstIndex(where: { $0.id == id }) else {
            return false
        }
        warehouses[index] = newWarehouse
        return true
    }
    
    
    func deleteOne(id: UUID) async -> Bool {
        guard let index = warehouses.firstIndex(where: { $0.id == id }) else {
                    return false
                }
                warehouses.remove(at: index)
                return true
    }
    
    
    func deleteAllWarehouse() async {
        warehouses.removeAll()
    }
    
}
