//
//  File.swift
//  
//
//  Created by Hugh on 8/9/2024.
//

import Foundation


extension Treasure.Chain {
    
    public func delete<C: Configuration>(
        configuration: C,
        session: Session
    ) async throws -> Void {
        
        let payload = Self.DeletionPayload(chain_id: self.indexid)
        
        try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .DELETE,
            requestBody: payload,
            session: session
        )
        
        return
        
    }
    
    private struct DeletionPayload: Encodable { let chain_id: Int }
    
}
