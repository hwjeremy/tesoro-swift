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
    public let disposition: Disposition
    
    public static let maxMessageLength = 280
    public static let minMessageLength = 1
    
    public static func create<C: Configuration>(
        configuration: C,
        session: Session,
        message: String,
        location: Self.Location,
        orientation: Float? = nil
    ) async throws -> Self {
        
        guard message.count <= Self.maxMessageLength else {
            throw TesoroError(clientFacingFriendlyMessage: """
Message length exceeds the maximum allowable: \(Self.maxMessageLength) \
characters.
""")
        }
        
        guard message.count >= Self.minMessageLength else {
            throw TesoroError(clientFacingFriendlyMessage: """
Message length is below the minimum allowable: \(Self.minMessageLength)
""")
        }
        
        let payload = CreatePayload(
            latitude: location.latitude,
            longitude: location.longitude,
            altitude: location.altitude,
            orientation: orientation,
            message: message
        )
        
        let treasure: Self = try await Request.make(
            configuration: configuration,
            path: Self.path,
            method: .POST,
            requestBody: payload,
            session: session
        )

        return treasure

    }
    
    private struct CreatePayload: Encodable {
        
        let latitude: Double
        let longitude: Double
        let altitude: Float
        let orientation: Float?
        let message: String
        
    }
    
    static func retrieveMany<C: Configuration>(
        configuration: C
    ) async throws -> Self {
        
        throw TesoroError.notImplemented
        
    }

}
