//
//  File.swift
//  
//
//  Created by Hugh on 4/9/2024.
//

import Foundation


extension Treasure {
    
    private static let closestUndiscoveredPath = Self.path
        + "/closest-undiscovered"
    
    private struct ClosestUndiscoveredResult: Decodable {
        let treasure: Treasure?
        let relative_to: Treasure.Location
    }
    
    public static func findClosestUndiscovered<C: Configuration>(
        relativeTo location: Self.Location,
        configuration: C,
        session: Session
    ) async throws -> Self? {
        
        let queryItems: Array<URLQueryItem> = [
            URLQueryItem(
                name: "rt_latitude",
                value: "\(location.latitude)"
            ),
            URLQueryItem(
                name: "rt_longitude",
                value: "\(location.longitude)"
            )
        ]
    
        let result: ClosestUndiscoveredResult = try await Request.make(
            configuration: configuration,
            path: Self.closestUndiscoveredPath,
            method: .GET,
            queryItems: queryItems,
            session: session
        )
        
        return result.treasure

    }
    
}
