//
//  File.swift
//  
//
//  Created by Hugh on 8/9/2024.
//

import Foundation


extension Treasure.Chain {
    
    public static func retrieve<C: Configuration>(
        withId indexid: Int,
        configuration: C,
        session: Session
    ) async throws -> Self {
        
        let result: Treasure.Chain = try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .GET,
            queryItems: [.init(name: "indexid", value: "\(indexid)")],
            session: session
        )
        
        return result
        
    }
    
}
