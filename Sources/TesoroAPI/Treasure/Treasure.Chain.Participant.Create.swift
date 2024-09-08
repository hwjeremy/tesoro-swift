//
//  File.swift
//  
//
//  Created by Hugh on 8/9/2024.
//

import Foundation


extension Treasure.Chain.Participant {
    
    public static func create<C: Configuration>(
        configuration: C,
        session: Session,
        chain: Treasure.Chain,
        newParticipant treasure: Treasure
    ) async throws -> Treasure.Chain {
        
        typealias Chain = Treasure.Chain
    
        guard chain.participantCount < Chain.MAX_PARTICIPANT_COUNT else {
            throw TesoroError(clientFacingFriendlyMessage: """
The subject Trail already has the maximum number of GeoData \
(\(Chain.MAX_PARTICIPANT_COUNT))
""")
        }
        
        guard treasure.chainPosition == nil else {
            throw TesoroError(clientFacingFriendlyMessage: """
The supplied GeoData is already participating in another Trail
""")
        }
        
        let payload = CreatePayload(
            chain_id: chain.indexid,
            treasure_id: treasure.indexid
        )
        
        let result: Chain = try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .POST,
            requestBody: payload,
            session: session
        )
        
        return result

    }
    
    private struct CreatePayload: Encodable {
        let chain_id: Int
        let treasure_id: Int
    }
    
}
