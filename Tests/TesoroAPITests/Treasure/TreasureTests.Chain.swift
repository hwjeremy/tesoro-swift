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
        
        let _ = try await Treasure.Discovery.create(
            configuration: configuration,
            session: session,
            treasure: p1,
            discoveringAgent: session
        )
        
        let p1r = try await p1.refresh(
            configuration: configuration,
            session: session
        )
        
        XCTAssert(p1r.chainPosition != nil)
        XCTAssert(p1r.chainPosition?.sequence == 1)
        XCTAssert(p1r.chainPosition?.chainId == chain.indexid)
        XCTAssert(p1r.hasBeenDiscovered(by: session) == true)
        XCTAssert(p1r.chainPosition?.previousParticipantFound == nil)
        
        let p2r = try await p2.refresh(
            configuration: configuration,
            session: session
        )
        
        XCTAssert(p2r.chainPosition != nil)
        XCTAssert(p2r.chainPosition?.sequence == 2)
        XCTAssert(p2r.chainPosition?.chainId == chain.indexid)
        XCTAssert(p2r.chainPosition?.previousParticipantFound == true)
        
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
