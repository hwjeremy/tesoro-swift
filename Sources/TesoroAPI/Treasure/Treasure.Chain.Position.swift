//
//  File.swift
//  
//
//  Created by Hugh on 8/9/2024.
//

import Foundation


extension Treasure.Chain {
    
    public struct Position: Decodable {
        
        let chainId: Int
        let sequence: Int
        let previousParticipantFound: Bool?
        
        private enum CodingKeys: String, CodingKey {
            case chainId = "chain_id"
            case sequence
            case previousParticipantFound = "previous_participant_found"
        }

    }
    
}
