//
//  File.swift
//  
//
//  Created by Hugh on 3/9/2024.
//

import Foundation


extension Treasure {
    
    public struct RetrievingAgentState: Decodable {
        
        public let retrievingAgentId: Int
        public let hasDiscovered: Bool
        public let hasRatedPositively: Bool
        public let hasRatedNegatively: Bool
        
        private enum CodingKeys: String, CodingKey {
            
            case retrievingAgentId = "retrieving_agent_id"
            case hasDiscovered = "has_discovered"
            case hasRatedPositively = "has_rated_positively"
            case hasRatedNegatively = "has_rated_negatively"

        }

    }
    
    public func hasBeenRatedPositively<A: Agent>(by agent: A) -> Bool? {
        guard let ras = self.retrievingAgentState else { return nil }
        guard ras.retrievingAgentId == agent.agentId else { return nil }
        return ras.hasRatedPositively
    }
    
    public func hasBeenRatedNegatively<A: Agent>(by agent: A) -> Bool? {
        guard let ras = self.retrievingAgentState else { return nil }
        guard ras.retrievingAgentId == agent.agentId else { return nil }
        return ras.hasRatedNegatively
    }
    
    public func hasBeenDiscovered<A: Agent>(by agent: A) -> Bool? {
        guard let ras = self.retrievingAgentState else { return nil }
        guard ras.retrievingAgentId == agent.agentId else { return nil }
        return ras.hasDiscovered
    }
    
}
