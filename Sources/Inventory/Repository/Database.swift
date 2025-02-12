//
//  Database.swift
//  Inventory
//
//  Created by Vinaydeep Singh Padda on 2025-02-12.
//

import Foundation

final class Database {
    let Parts: [Part] = []
    let Warehouse: [WareHouse] = []
    
   static let sharedDatabase = Database()
    private init() {}
    


    
}
