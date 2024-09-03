//
//  File.swift
//  
//
//  Created by Hugh on 31/8/2024.
//

import Foundation


public enum AuthorAgent: Agent {
    
    case session(Session)
    case author(Author)
    
    public var agentId: Int {
        switch self {
        case .author(let author): return author.agentId
        case .session(let session): return session.agentId
        }
    }
    
}
