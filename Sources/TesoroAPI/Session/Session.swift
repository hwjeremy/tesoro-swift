//
//  File.swift
//  
//
//  Created by Hugh on 22/8/2024.
//

import Foundation


public struct Session: Decodable, Agent {
    
    internal static let path = "/session"
    internal static let headerIdName = "X-Session-ID"
    
    public let agentId: Int
    public let sessionId: String
    public let apiKey: String
    
    private enum CodingKeys: String, CodingKey {
        case agentId = "agent_id"
        case sessionId = "session_id"
        case apiKey = "api_key"
    }
    
    public init(agentId: Int, sessionId: String, apiKey: String) {
        self.agentId = agentId
        self.sessionId = sessionId
        self.apiKey = apiKey
    }
    
}
