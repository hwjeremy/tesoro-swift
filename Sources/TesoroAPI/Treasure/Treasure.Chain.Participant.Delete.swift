//
//  File.swift
//  
//
//  Created by Hugh on 8/9/2024.
//

import Foundation


extension Treasure.Chain.Participant {
    
    public static func delete<C: Configuration>(
        _ treasure: Treasure,
        from chain: Treasure.Chain,
        configuration: C,
        session: Session
    ) async throws -> Treasure.Chain {
        
        typealias Chain = Treasure.Chain
        
        guard chain.participantCount > Chain.MIN_PARTICIPANT_COUNT else {
            throw TesoroError(clientFacingFriendlyMessage: """
Deleting this GeoData from the Trail would cause the Trail to drop below the \
minimum participant count (\(Chain.MAX_PARTICIPANT_COUNT)), you may wish to \
delete the Trail itself instead.
""")
        }
        
        let payload = Self.DeletePayload(
            chain_id: chain.indexid,
            treasure_id: treasure.indexid
        )
        
        let result: Chain = try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .DELETE,
            requestBody: payload,
            session: session
        )
        
        return result
        
    }
    
    private struct DeletePayload: Encodable {
        let chain_id: Int
        let treasure_id: Int
    }
    
}
