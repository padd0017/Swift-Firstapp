//
//  WarehouseTests.swift
//  Inventory
//
//  Created by Mohamed El-Halawani on 2025-02-04.
//

import Foundation
import Testing
import Logging
import Hummingbird
import HummingbirdTesting

@testable import Inventory

@Suite(.serialized)
struct WarehouseTests {
    
    struct TestArguments: AppArguments {
        let hostname = "127.0.0.1"
        let port = 0
        let logLevel: Logger.Level? = .trace
    }
    
    static func create(name: String, location: Location, contact: String, manager: String?, client: some TestClientProtocol) async throws -> Warehouse {
        let request = Warehouse(id: UUID(), name: name, location: location, contactNumber: contact, manager: manager)
        let buffer = try JSONEncoder().encodeAsByteBuffer(request, allocator: ByteBufferAllocator())
        
        return try await client.execute(uri: "/warehouses", method: .post, body: buffer) { response in
            return try JSONDecoder().decode(Warehouse.self, from: response.body)
        }
    }

    @Test func create() async throws {
        let id = UUID()
        let expected = Warehouse(
            id: id,
            name: "Warehouse 1",
            location: Location(city: "Ottawa", country: "Canada", address: "1 City ST"),
            contactNumber: "6131234567",
            manager: "John"
        )

        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let Warehouse = try await Self.create(
                name: expected.name,
                location: expected.location,
                contact: expected.contactNumber,
                manager: expected.manager,
                client: client
            )
            
            #expect(Warehouse.name == expected.name)
        }
    }
    
    static func get(id: UUID, client: some TestClientProtocol) async throws -> Warehouse? {
        try await client.execute(uri: "/warehouses/\(id)", method: .get) { response in
            if response.body.readableBytes > 0 {
                return try JSONDecoder().decode(Warehouse.self, from: response.body)
            } else {
                return nil
            }
        }
    }
    
    @Test func get() async throws {
        let id = UUID()
        let expected = Warehouse(
            id: id,
            name: "Warehouse 1",
            location: Location(city: "Ottawa", country: "Canada", address: "1 City ST"),
            contactNumber: "6131234567",
            manager: "John"
        )

        let _ = Database.shared.add(element: expected)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.get(id: expected.id, client: client)
            
            #expect(actual?.id == expected.id)
        }
    }
    
    
    static func list(client: some TestClientProtocol) async throws -> [Warehouse] {
        try await client.execute(uri: "/warehouses", method: .get) { response in
             return  try JSONDecoder().decode([Warehouse].self, from: response.body)
        }
    }
    
    @Test func list() async throws {
        let expected1 = Warehouse(
            id: UUID(),
            name: "Warehouse 1",
            location: Location(city: "Ottawa", country: "Canada", address: "1 City ST"),
            contactNumber: "6131234567",
            manager: "John"
        )
        
        let expected2 = Warehouse(
            id: UUID(),
            name: "Warehouse 2",
            location: Location(city: "Ottawa", country: "Canada", address: "15 Downtown ST"),
            contactNumber: "613176543",
            manager: "Mike"
        )
        
        let _ = Database.shared.add(element: expected1)
        let _ = Database.shared.add(element: expected2)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.list(client: client)
            #expect(actual.count >= 2)
        }
        
    }
    
    static func patch(id: UUID, name: String, location: Location, contactNumber: String, manager: String?, client: some TestClientProtocol) async throws -> Warehouse? {
        let request = Warehouse(
            id: id,
            name: name,
            location: location,
            contactNumber: contactNumber,
            manager: manager
        )
        
        let buffer = try JSONEncoder().encodeAsByteBuffer(request, allocator: ByteBufferAllocator())
        return try await client.execute(uri: "/warehouses/\(id)", method: .patch, body: buffer) { response in
            if response.body.readableBytes > 0 {
                return try JSONDecoder().decode(Warehouse.self, from: response.body)
            } else {
                return nil
            }
        }
    }
    
    @Test func update() async throws {
        let id = UUID()
        let expected1 = Warehouse(
            id: id,
            name: "Warehouse 1",
            location: Location(city: "Ottawa", country: "Canada", address: "1 City ST"),
            contactNumber: "6131234567",
            manager: "John"
        )
        
        let _ = Database.shared.add(element: expected1)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.patch(id: id, name: "Updated Warehouse 1", location: expected1.location, contactNumber: expected1.contactNumber, manager: expected1.manager, client: client)
            #expect(actual?.name == "Updated Warehouse 1")
        }
        
    }
    
    static func delete(id: UUID, client: some TestClientProtocol) async throws -> HTTPResponse.Status {
        try await client.execute(uri: "/warehouses/\(id)", method: .delete) { response in
            response.status
        }
    }
    
    @Test func delete() async throws {
        let id = UUID()
        let expected1 = Warehouse(
            id: id,
            name: "Warehouse 1",
            location: Location(city: "Ottawa", country: "Canada", address: "1 City ST"),
            contactNumber: "6131234567",
            manager: "John"
        )
        
        let expected2 = Warehouse(
            id: UUID(),
            name: "Warehouse 2",
            location: Location(city: "Ottawa", country: "Canada", address: "15 Downtown ST"),
            contactNumber: "613176543",
            manager: "Mike"
        )
        
        let _ = Database.shared.add(element: expected1)
        let _ = Database.shared.add(element: expected2)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.delete(id: id, client: client)
            #expect(actual == .ok)
        }
    }
    
    static func deleteAll(client: some TestClientProtocol) async throws -> HTTPResponse.Status {
        try await client.execute(uri: "/warehouses", method: .delete) { response in
            response.status
        }
    }
    
    @Test func deleteAll() async throws {
        let id = UUID()
        let expected1 = Warehouse(
            id: id,
            name: "Warehouse 1",
            location: Location(city: "Ottawa", country: "Canada", address: "1 City ST"),
            contactNumber: "6131234567",
            manager: "John"
        )
        
        let expected2 = Warehouse(
            id: UUID(),
            name: "Warehouse 2",
            location: Location(city: "Ottawa", country: "Canada", address: "15 Downtown ST"),
            contactNumber: "613176543",
            manager: "Mike"
        )
        
        let _ = Database.shared.add(element: expected1)
        let _ = Database.shared.add(element: expected2)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.deleteAll(client: client)
            #expect(actual == .ok)
        }
    }
}

