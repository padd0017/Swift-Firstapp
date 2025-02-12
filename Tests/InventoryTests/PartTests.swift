//
//  PartTests.swift
//  Inventory
//
//  Created by Mohamed El-Halawani on 2025-02-02.
//

import Foundation
import Testing
import Logging
import Hummingbird
import HummingbirdTesting

@testable import Inventory

@Suite(.serialized)
struct PartTests {
    
    struct TestArguments: AppArguments {
        let hostname = "127.0.0.1"
        let port = 0
        let logLevel: Logger.Level? = .trace
    }
    
    static func create(name: String, category: PartCategory, size: Dimensions? , weight: Double?, client: some TestClientProtocol) async throws -> Part {
        let request = Part(id: UUID(), name: name, category: category, size: size, weight: weight)
        let buffer = try JSONEncoder().encodeAsByteBuffer(request, allocator: ByteBufferAllocator())
        
        return try await client.execute(uri: "/parts", method: .post, body: buffer) { response in
            return try JSONDecoder().decode(Part.self, from: response.body)
        }
    }

    @Test func create() async throws {
        let id = UUID()
        let expectedPart = Part(id: id, name: "Part 1", category: .engine, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let part = try await Self.create(
                name: expectedPart.name,
                category: expectedPart.category,
                size: expectedPart.size,
                weight: expectedPart.weight,
                client: client
            )
            
            #expect(part.name == expectedPart.name)
        }
    }
    
    static func get(id: UUID, client: some TestClientProtocol) async throws -> Part? {
        try await client.execute(uri: "/parts/\(id)", method: .get) { response in
            if response.body.readableBytes > 0 {
                return try JSONDecoder().decode(Part.self, from: response.body)
            } else {
                return nil
            }
        }
    }
    
    @Test func get() async throws {
        let id = UUID()
        let expected = Part(id: id, name: "Part 1", category: .engine, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        let _ = Database.shared.add(element: expected)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.get(id: expected.id, client: client)
            
            #expect(actual?.id == expected.id)
        }
    }
    
    
    static func list(client: some TestClientProtocol) async throws -> [Part] {
        try await client.execute(uri: "/parts", method: .get) { response in
             return  try JSONDecoder().decode([Part].self, from: response.body)
        }
    }
    
    @Test func list() async throws {
        let expected1 = Part(id: UUID(), name: "Part 1", category: .engine, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        let expected2 = Part(id: UUID(), name: "Part 2", category: .exterior, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        
        let _ = Database.shared.add(element: expected1)
        let _ = Database.shared.add(element: expected2)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.list(client: client)
            #expect(actual.count >= 2)
        }
        
    }
    
    static func patch(id: UUID, name: String, category: PartCategory, size: Dimensions?, weight: Double?, client: some TestClientProtocol) async throws -> Part? {
        let request = Part(id: id, name: name, category: category, size: size, weight: weight)
        let buffer = try JSONEncoder().encodeAsByteBuffer(request, allocator: ByteBufferAllocator())
        return try await client.execute(uri: "/parts/\(id)", method: .patch, body: buffer) { response in
            if response.body.readableBytes > 0 {
                return try JSONDecoder().decode(Part.self, from: response.body)
            } else {
                return nil
            }
        }
    }
    
    @Test func update() async throws {
        let id = UUID()
        let expected1 = Part(id: id, name: "Part 1", category: .engine, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        
        let _ = Database.shared.add(element: expected1)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.patch(id: id, name: "Updated Part 1", category: expected1.category, size: expected1.size, weight: expected1.weight, client: client)
            #expect(actual?.name == "Updated Part 1")
        }
        
    }
    
    static func delete(id: UUID, client: some TestClientProtocol) async throws -> HTTPResponse.Status {
        try await client.execute(uri: "/parts/\(id)", method: .delete) { response in
            response.status
        }
    }
    
    @Test func delete() async throws {
        let id = UUID()
        let expected1 = Part(id: id, name: "Part 1", category: .engine, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        let expected2 = Part(id: UUID(), name: "Part 2", category: .exterior, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        
        let _ = Database.shared.add(element: expected1)
        let _ = Database.shared.add(element: expected2)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.delete(id: id, client: client)
            #expect(actual == .ok)
        }
    }
    
    static func deleteAll(client: some TestClientProtocol) async throws -> HTTPResponse.Status {
        try await client.execute(uri: "/parts", method: .delete) { response in
            response.status
        }
    }
    
    @Test func deleteAll() async throws {
        let id = UUID()
        let expected1 = Part(id: id, name: "Part 1", category: .engine, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        let expected2 = Part(id: UUID(), name: "Part 2", category: .exterior, size: .init(hight: 10, width: 20, length: 30), weight: 12)
        
        let _ = Database.shared.add(element: expected1)
        let _ = Database.shared.add(element: expected2)
        
        let app = try await buildApplication(TestArguments())
        try await app.test(.router) { client in
            let actual = try await Self.deleteAll(client: client)
            #expect(actual == .ok)
        }
    }
}

