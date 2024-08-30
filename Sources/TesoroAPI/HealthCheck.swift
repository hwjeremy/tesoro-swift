//
//  File.swift
//  
//
//  Created by Hugh on 27/8/2024.
//

import Foundation


public struct HealthCheck: Decodable {

    internal static let path = "/health-check"
    
    public let created: Date
    
    public static func retrieve<C: Configuration>(
        configuration: C,
        session: Session?
    ) async throws -> Self {
        
        let result: Self = try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .GET,
            session: session
        )
        
        return result
        
    }
    
}
