//
//  File.swift
//  
//
//  Created by Hugh on 21/8/2024.
//

import Foundation


public struct Treasure: Decodable {
    
    internal static let path = "/treasure"
    
    public let indexid: Int
    public let created: Date
    public let message: String
    public let author: Author
    public let location: Self.Location
    public let distance: Double?
    public let orientation: Float?
    public let discoveryCount: Int
    public let positiveRatingCount: Int
    public let negativeRatingCount: Int
    public let retrievingAgentState: RetrievingAgentState?
    public let retrieved: Date
    public let chainPosition: Chain.Position?
    public let disposition: Disposition
    
    public static let maxMessageLength = 280
    public static let minMessageLength = 1
    
    private enum CodingKeys: String, CodingKey {
        
        case indexid
        case created
        case message
        case author
        case location
        case distance
        case orientation
        case discoveryCount = "discovery_count"
        case positiveRatingCount = "positive_rating_count"
        case negativeRatingCount = "negative_rating_count"
        case retrievingAgentState = "retrieving_agent_state"
        case retrieved
        case chainPosition = "chain_position"
        case disposition

    }

}
