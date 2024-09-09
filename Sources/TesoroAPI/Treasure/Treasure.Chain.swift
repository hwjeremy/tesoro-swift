//
//  File.swift
//  
//
//  Created by Hugh on 8/9/2024.
//

import Foundation


extension Treasure {
    
    public struct Chain: Decodable {
        
        public static let MAX_PARTICIPANT_COUNT = 10
        public static let MIN_PARTICIPANT_COUNT = 2
        
        internal static let path = Treasure.path + "/chain"
        
        public let indexid: Int
        public let authorId: Int
        public let participantTreasureIds: Array<Int>
        
        public var participantCount: Int {
            return self.participantTreasureIds.count
        }
        
        private enum CodingKeys: String, CodingKey {
            
            case indexid
            case authorId = "author_id"
            case participantTreasureIds = "participant_ids"
    
        }
        
        public enum Participation {
            
            case notParticipatingInAnyChain
            case participatingInAnyChain
            case participatingInASpecificChain(Treasure.Chain)
            case any
            
            internal func makeQueryItems() -> Array<URLQueryItem> {
                
                var queryItems = Array<URLQueryItem>()
                
                switch self {
                case .any:
                    return queryItems
                case .notParticipatingInAnyChain:
                    queryItems.append(.init(
                       name: "included_in_any_chain",
                       value: "\(false)"
                   ))
                case .participatingInAnyChain:
                    queryItems.append(.init(
                       name: "included_in_any_chain",
                       value: "\(true)"
                   ))
                case .participatingInASpecificChain(let chain):
                    queryItems.append(.init(
                       name: "participating_in_chain",
                       value: "\(chain.indexid)"
                   ))
                }
                
                return queryItems
                
            }
    
        }

    }
    
}


extension Treasure.Chain: Equatable, Hashable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return (
            lhs.indexid == rhs.indexid
            && lhs.participantTreasureIds == rhs.participantTreasureIds
        )
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.indexid)
        hasher.combine(self.participantTreasureIds)
        return
    }
    
}


extension Treasure.Chain: Identifiable {
    
    public var id: Int { return self.indexid }

}

extension Treasure.Chain.Participation? {
    
    internal func makeQueryItems() -> Array<URLQueryItem> {
    
        guard let realised = self else { return [] }
        
        return realised.makeQueryItems()
        
    }
    
}
