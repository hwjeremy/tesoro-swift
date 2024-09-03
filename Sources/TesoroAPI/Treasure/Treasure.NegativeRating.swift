//
//  File.swift
//  
//
//  Created by Hugh on 3/9/2024.
//

import Foundation


extension Treasure {
    
    public struct NegativeRating {
        
        static let path = Treasure.path + "/negative-rating"
        
        public static func create<C: Configuration, A: Agent>(
            configuration: C,
            session: Session,
            treasure: Treasure,
            ratingAgent: A
        ) async throws -> Treasure {
            
            guard treasure.hasBeenRatedNegatively(
                by: ratingAgent
            ) != true else {
                throw TesoroError(clientFacingFriendlyMessage: """
This GeoData has already been rated negatively
""")
            }
            
            let payload = Self.Payload(
                treasure: treasure.indexid,
                rating_agent: ratingAgent.agentId
            )
            
            let treasure: Treasure = try await Request.make(
                configuration: configuration,
                path: Self.path,
                method: .POST,
                requestBody: payload,
                session: session
            )
            
            return treasure
            
        }

        private struct Payload: Encodable {
            let treasure: Int
            let rating_agent: Int
        }
        
        public static func delete<C: Configuration, A: Agent>(
            configuration: C,
            session: Session,
            treasure: Treasure,
            ratingAgent: A
        ) async throws -> Treasure {
            
            guard treasure.hasBeenRatedNegatively(
                by: ratingAgent
            ) != false else {
                throw TesoroError(clientFacingFriendlyMessage: """
This GeoData is not rated negatively
""")
            }
            
            let payload = Self.Payload(
                treasure: treasure.indexid,
                rating_agent: ratingAgent.agentId
            )
            
            let treasure: Treasure = try await Request.make(
                configuration: configuration,
                path: Self.path,
                method: .DELETE,
                requestBody: payload,
                session: session
            )
            
            return treasure
            
        }
        
    }
    
}
