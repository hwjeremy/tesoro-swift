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
            latitude: Double.random(in: -7000...7000) / 100,
            longitude: Double.random(in: -11000...11000) / 100,
            altitude: Float.random(in: 0...2000) / 100
        )
    }
    
}
