//
//  File.swift
//  
//
//  Created by Hugh on 3/9/2024.
//

import Foundation


extension Treasure {
    
    public struct Discovery {
        
        static let path = Treasure.path + "/discovery"
        
        public static func create<C: Configuration, A: Agent>(
            configuration: C,
            session: Session,
            treasure: Treasure,
            discoveringAgent: A
        ) async throws -> Void {
            
            guard treasure.hasBeenDiscovered(
                by: discoveringAgent
            ) != true else {
                throw TesoroError(clientFacingFriendlyMessage: """
This GeoData has already been discovered.
""")
            }
            
            let payload = Self.CreatePayload(
                treasure: treasure.indexid,
                discovering_agent: discoveringAgent.agentId
            )
            
            try await Request.make(
                configuration: configuration,
                path: Self.path,
                method: .POST,
                requestBody: payload,
                session: session
            )
            
            return
            
        }

        private struct CreatePayload: Encodable {
            let treasure: Int
            let discovering_agent: Int
        }
        
    }
    
}
