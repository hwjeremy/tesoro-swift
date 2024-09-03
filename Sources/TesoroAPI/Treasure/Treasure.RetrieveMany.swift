//
//  File.swift
//  
//
//  Created by Hugh on 31/8/2024.
//

import Foundation


extension Treasure {
    
    private static let retrieveManyPath = Self.path + "/many"
    
    public static func retrieveMany<C: Configuration>(
        configuration: C,
        session: Session,
        author: AuthorAgent? = nil,
        relativeTo relativeToLocation: Location? = nil,
        discoveredBy discoveringAgent: AuthorAgent? = nil,
        order: Order = Order.descending,
        orderBy: Self.OrderBy = .created,
        limit: Int = 10,
        offset: Int = 0
    ) async throws -> Array<Self> {
        
        guard limit > 0 else {
            throw TesoroError(clientFacingFriendlyMessage: "Limit must be > 0")
        }
        
        guard offset >= 0 else {
            throw TesoroError(clientFacingFriendlyMessage: """
Offset must be >= 0
""")
        }
        
        if orderBy == .distance && relativeToLocation == nil {
            throw TesoroError(clientFacingFriendlyMessage: """
When ordering by distance, a relative-to location must be supplied
""")
        }
        
        var queryItems: Array<URLQueryItem> = [
            .init(name: "limit", value: "\(limit)"),
            .init(name: "offset", value: "\(offset)"),
            .init(name: "order", value: order.rawValue),
            .init(name: "order_by", value: orderBy.rawValue)
        ]
        
        if let a = author {
            queryItems.append(.init(name: "author", value: "\(a.agentId)"))
        }
        
        if let rtl = relativeToLocation {
            queryItems.append(.init(
                name: "rt_latitude",
                value: "\(rtl.latitude)"
            ))
            queryItems.append(.init(
                name: "rt_longitude",
                value: "\(rtl.longitude)"
            ))
        }
        
        if let d = discoveringAgent {
            queryItems.append(.init(
                name: "discovering_agent",
                value: "\(d.agentId)"
            ))
        }
        
        let results: Array<Self> = try await Request.make(
            configuration: configuration,
            path: Self.retrieveManyPath,
            method: .GET,
            queryItems: queryItems,
            session: session
        )
        
        return results
        
    }
    
    public enum OrderBy: String, Hashable, Equatable, CaseIterable,
                            Identifiable {
        
        case created = "created"
        case distance = "distance"
        case rating = "rating"
        
        public var id: String { return self.rawValue }

    }

}
