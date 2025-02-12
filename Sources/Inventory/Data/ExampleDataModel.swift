//
//  ExampleDataModel.swift
//  Inventory
//
//  Created by Mohamed El-Halawani on 2025-02-03.
//

import Foundation
import Hummingbird

// This is an example data model object.
struct ExampleDataModel {
    let id: UUID
    let name: String
}

// Every data model you create MUST contain this line (DON'T forget to change the object name)
extension ExampleDataModel: ResponseEncodable, Decodable, Equatable {}
