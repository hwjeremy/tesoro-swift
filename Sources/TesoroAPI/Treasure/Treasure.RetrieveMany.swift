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
        
        var queryItems: Array<URLQueryItem> = [
            .init(name: "limit", value: "\(limit)"),
            .init(name: "offset", value: "\(offset)"),
            .init(name: "order", value: order.rawValue),
            .init(name: "order_by", value: orderBy.rawValue)
        ]
        
        if let a = author {
            queryItems.append(.init(name: "author", value: "\(a.agentId)"))
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
        case location = "location"
        case rating = "rating"
        
        public var id: String { return self.rawValue }

    }

}
