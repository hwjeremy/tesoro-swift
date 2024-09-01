//
//  File.swift
//  
//
//  Created by Hugh on 21/8/2024.
//

import Foundation
import CoreLocation

extension Treasure {
    
    public struct Location: Codable {
        
        public let latitude: Double
        public let longitude: Double
        public let altitude: Float
        
        public init(latitude: Double, longitude: Double, altitude: Float) {
            self.latitude = latitude
            self.longitude = longitude
            self.altitude = altitude
        }
        
        public static func from(_ location: CLLocation) -> Self {
            return Self(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                altitude: Float(location.altitude)
            )
        }
        
        public static func from(_ location: CLLocation?) -> Self? {
            guard let location = location else { return nil }
            return Self.from(location)
        }
        

    }

}


extension Treasure.Location {
    
    public static let example: Self = .init(
        latitude: -31.537,
        longitude: 159.074,
        altitude: 2.0
    )
    
}
