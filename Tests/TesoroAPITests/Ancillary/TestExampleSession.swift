//
//  File.swift
//  
//
//  Created by Hugh on 28/8/2024.
//

import Foundation
@testable import TesoroAPI


extension Session {
    
    static func fromCommandLine() -> Self {
        
        guard let sid = TesoroAPI.CommandLine.valueFor(key: "session-id") else {
            fatalError("Supply session-id argument")
        }
        
        guard let apk = CommandLine.valueFor(key: "api-key") else {
            fatalError("Supply api-key argument")
        }
        
        guard let raid = CommandLine.valueFor(key: "agent-id"),
              let iaid = Int(raid) else {
            fatalError("Supply integer agent-id argument")
        }
        
        return Session(agentId: iaid, sessionId: sid, apiKey: apk)
        
    }
    
}
