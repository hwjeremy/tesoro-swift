//
//  File.swift
//  
//
//  Created by Hugh on 8/9/2024.
//

import Foundation
import TesoroAPI
import XCTest


extension TreasureTests {
    
    func testCreateRetrieveDeleteChain() async throws -> Void {
        
        let configuration = TestConfiguration()
        let session = Session.fromCommandLine()
        
        let p1 = try await Treasure.create(
            configuration: configuration,
            session: session,
            message: "Test treasure for Chain creation",
            location: .randomForTesting()
        )
        
        let p2 = try await Treasure.create(
            configuration: configuration,
            session: session,
            message: "Test treasure for Chain creation",
            location: .randomForTesting()
        )
        
        let chain = try await Treasure.Chain.create(
            configuration: configuration,
            session: session,
            participants: [p1, p2]
        )
        
        XCTAssert(chain.participantTreasureIds.contains(p1.indexid))
        XCTAssert(chain.participantTreasureIds.contains(p2.indexid))
        XCTAssert(chain.participantTreasureIds.count == 2)
        
        let retrievedChain = try await Treasure.Chain.retrieve(
            withId: chain.indexid,
            configuration: configuration,
            session: session
        )
        
        XCTAssert(retrievedChain == chain)
        
        try await retrievedChain.delete(
            configuration: configuration,
            session: session
        )
        
        
        var didHave404 = false
        do {
            
            let _ = try await Treasure.Chain.retrieve(
                withId: chain.indexid,
                configuration: configuration,
                session: session
            )
            
        } catch let apiError as TesoroError {
            
            if apiError.clientFacingFriendlyMessage == """
The Tesoro API responded to a request with a 404 code
""" {
                didHave404 = true
            }
            
        }
        
        XCTAssert(didHave404 == true)
        
        return
        
    }
    
    func testDeleteChain() async throws -> Void {
        
        
        
    }
    
}
