//
//  File.swift
//  
//
//  Created by Hugh on 31/8/2024.
//

import Foundation


extension Treasure {
    
    public func delete<C: Configuration>(
        configuration: C,
        session: Session
    ) async throws -> Void {
        
        let queryItems: Array<URLQueryItem> = [
            .init(name: "indexid", value: "\(self.indexid)")
        ]
        
        try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .DELETE,
            queryItems: queryItems,
            session: session
        )
        
        return

    }
    
}
