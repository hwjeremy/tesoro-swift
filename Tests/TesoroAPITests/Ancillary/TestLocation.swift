//
//  File.swift
//  
//
//  Created by Hugh on 24/8/2024.
//

import Foundation
import TesoroAPI

extension Treasure.Location {
    
    static let testLocation = Self(
        latitude: -31.537,
        longitude: 159.074,
        altitude: 2.0
    )
    
    static func randomForTesting() -> Self {
        return Self(
            latitude: Double.random(in: -70...70),
            longitude: Double.random(in: -110...110),
            altitude: Float.random(in: 0...20)
        )
    }
    
}
