//
//  File.swift
//  
//
//  Created by Hugh on 8/9/2024.
//

import Foundation


extension Treasure.Chain {
    
    public static func create<C: Configuration>(
        configuration: C,
        session: Session,
        participants: Array<Treasure>
    ) async throws -> Self {
        
        guard participants.count >= Self.MIN_PARTICIPANT_COUNT else {
            throw TesoroError(clientFacingFriendlyMessage: """
A Trail requires a minimum of \(Self.MIN_PARTICIPANT_COUNT) GeoData
""")
        }
        
        guard participants.count <= Self.MAX_PARTICIPANT_COUNT else {
            throw TesoroError(clientFacingFriendlyMessage: """
A Trail can contain a maximum of \(Self.MAX_PARTICIPANT_COUNT) GeoData
""")
        }
        
        for participant in participants {
    
            guard participant.chainPosition == nil else {
                throw TesoroError(clientFacingFriendlyMessage: """
GeoData \(participant.indexid) is already part of another Trail
""")
            }
            
        }
        
        let uniquePartipantIds: Set<Int> = Set(
            participants.map { return $0.indexid }
        )
        
        guard uniquePartipantIds.count == participants.count else {
            throw TesoroError(clientFacingFriendlyMessage: """
Each of the GeoData participating in a Trail must be unique
""")
        }
        
        let payload = Self.CreatePayload(
            participant_treasure_ids: participants.map { $0.indexid }
        )
        
        let chain: Self = try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .POST,
            requestBody: payload,
            session: session
        )
        
        return chain
        
    }

    private struct CreatePayload: Encodable {
        let participant_treasure_ids: Array<Int>
    }
    
}
