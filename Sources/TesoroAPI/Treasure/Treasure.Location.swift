//
//  File.swift
//  
//
//  Created by Hugh on 21/8/2024.
//

import Foundation
#if canImport(CoreLocation)
import CoreLocation
#endif

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
        
        #if canImport(CoreLocation)
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
        
        func toClLocation() -> CLLocation {
            return CLLocation(
                latitude: self.latitude,
                longitude: self.longitude
            )
        }
        
        func toClLocationCoordinate2D() -> CLLocationCoordinate2D {
            return CLLocationCoordinate2D(
                latitude: self.latitude,
                longitude: self.longitude
            )
        }
        #endif
        

    }

}


extension Treasure.Location {
    
    public static let example: Self = .init(
        latitude: -31.537,
        longitude: 159.074,
        altitude: 2.0
    )
    
}
