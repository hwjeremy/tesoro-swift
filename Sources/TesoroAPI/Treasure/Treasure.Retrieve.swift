//
//  File.swift
//  
//
//  Created by Hugh on 31/8/2024.
//

import Foundation

extension Treasure {
    
    private static let retrieveManyPath = Self.path + "/many"
    
    public static func retrieve<C: Configuration>(
        configuration: C,
        session: Session,
        indexid: Int
    ) async throws -> Self {
        
        let queryItems: Array<URLQueryItem> = [
            .init(name: "indexid", value: "\(indexid)")
        ]

        let result: Self = try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .GET,
            queryItems: queryItems,
            session: session
        )
        
        return result
        
    }
    
    
}
