//
//  ExampleDataModel.swift
//  Inventory
//
//  Created by Mohamed El-Halawani on 2025-02-03.
//

import Foundation
import Hummingbird

// This is an example data model object.

enum Category: String, Codable {
    case engine
    case transmission
    case breaks
    case body
    
}


struct Part {
    let id: UUID
    let name: String
    let category: Category
    let size: [String]
    let weight: Double
}

struct WareHouse {
    let id: UUID
    let name: String
    let location:  [String]
    let contactNumber: String
    let manager: String
}




// Every data model you create MUST contain this line (DON'T forget to change the object name)
extension Part: ResponseEncodable, Decodable, Equatable {}
extension WareHouse: ResponseEncodable, Decodable, Equatable {}
