//
//  WarehouseController.swift
//  Inventory
//
//  Created by Mohamed El-Halawani on 2025-02-04.
//

import Foundation
import Hummingbird

struct WarehouseController<Repository: WarehouseRepository> {
    let repository: Repository
    
    var endpoints: RouteCollection<AppRequestContext> {
        return RouteCollection(context: AppRequestContext.self)
            .get(":id", use: get)
            .get(use: list)
            .post(use: create)
            .patch(":id", use: update)
            .delete(":id", use: delete)
            .delete(use: deleteAll)
    }
    
    @Sendable func get(request: Request, context: some RequestContext) async throws -> Warehouse? {
        let id = try context.parameters.require("id", as: UUID.self)
        return try await self.repository.get(id: id)
    }
    
    @Sendable func create(request: Request, context: some RequestContext) async throws -> EditedResponse<Warehouse?> {
        
        let request = try await request.decode(as: Warehouse.self, context: context)
        
        if let warehouse = try await self.repository.create(
            name: request.name,
            location: request.location,
            contact: request.contactNumber,
            manager: request.manager
        ) {
            return EditedResponse(status: .created, response: warehouse)
        }
        
        return EditedResponse(status: .notImplemented, response: nil)
    }
    
    @Sendable func list(request: Request, context: some RequestContext) async throws -> [Warehouse] {
        return try await self.repository.list()
    }
    
    @Sendable func update(request: Request, context: some RequestContext) async throws -> Warehouse? {
        let id = try context.parameters.require("id", as: UUID.self)
        let request = try await request.decode(as: Warehouse.self, context: context)
        guard let warehouse = try await self.repository.update(
            id: id,
            name: request.name,
            location: request.location,
            contact: request.contactNumber,
            manager: request.manager
        ) else {
            throw HTTPError(.badRequest)
        }
        return warehouse
    }
    
    @Sendable func delete(request: Request, context: some RequestContext) async throws -> HTTPResponse.Status {
        let id = try context.parameters.require("id", as: UUID.self)
        if try await self.repository.delete(id: id) {
            return .ok
        } else {
            return .badRequest
        }
    }
    
    @Sendable func deleteAll(request: Request, context: some RequestContext) async throws -> HTTPResponse.Status {
        if try await self.repository.deleteAll() {
            return .ok
        }
        
        return .badRequest
    }
}
