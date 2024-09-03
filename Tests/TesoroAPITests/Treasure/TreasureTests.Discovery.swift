//
//  File.swift
//  
//
//  Created by Hugh on 3/9/2024.
//

import Foundation
import TesoroAPI
import XCTest


extension TreasureTests {
    
    func testDiscoverTreasure() async throws {
        
        let configuration = TestConfiguration()
        let session = Session.fromCommandLine()
    
        let subject = try await Treasure.create(
            configuration: configuration,
            session: session,
            message: "Test treasure for discovery",
            location: .init(
                latitude: Double.random(in: -70...70),
                longitude: Double.random(in: -110...110),
                altitude: Float.random(in: 0...20)
            )
        )
        
        guard subject.hasBeenDiscovered(by: session) == false else {
            XCTFail(); return
        }
        
        let _ = try await Treasure.Discovery.create(
            configuration: configuration,
            session: session,
            treasure: subject,
            discoveringAgent: session
        )
        
        let discoveredSubject = try await subject.refresh(
            configuration: configuration,
            session: session
        )

        guard discoveredSubject.hasBeenDiscovered(by: session) == true else {
            XCTFail(); return
        }
        
        return
        
    }
    
}
