//
//  File.swift
//  
//
//  Created by Hugh on 21/8/2024.
//

import Foundation


public struct Author: Codable {
    
    public let agentId: Int
    public let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case agentId = "agent_id"
        case name
    }

}
