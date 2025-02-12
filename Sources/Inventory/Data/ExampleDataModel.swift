//
//  ExampleDataModel.swift
//  Inventory
//
//  Created by Mohamed El-Halawani on 2025-02-03.
//

import Foundation
import Hummingbird

// This is an example data model object.
struct Part {
    let id: UUID
    let name: String
    let category: Category
    let size: [String]
    let weight: Double
}

struct Warehiuse {
    let id: UUID
    let name: String
    let location:  [String]
    let contactNumber: String
    let manager: String
}




// Every data model you create MUST contain this line (DON'T forget to change the object name)
extension Part: ResponseEncodable, Decodable, Equatable {}
extension WareHouse: ResponseEncodable, Decodable, Equatable {}
extension Size: ResponseEncodable, Decodable, Equatable {}
extension Location: ResponseEncodable, Decodable, Equatable {}
