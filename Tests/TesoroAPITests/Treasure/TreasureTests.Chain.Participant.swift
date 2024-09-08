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
    
    func testCreateDeleteChainParticipants() async throws -> Void {
        
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
        
        let p3 = try await Treasure.create(
            configuration: configuration,
            session: session,
            message: "Test treasure for Chain creation",
            location: .randomForTesting()
        )
        
        let p3Chain = try await Treasure.Chain.Participant.create(
            configuration: configuration,
            session: session,
            chain: chain,
            newParticipant: p3
        )
        
        XCTAssert(p3Chain.indexid == chain.indexid)
        XCTAssert(p3Chain != chain)
        XCTAssert(p3Chain.participantCount == 3)
        XCTAssert(p3Chain.participantTreasureIds.contains(p3.indexid))
        
        let dChain = try await Treasure.Chain.Participant.delete(
            p2,
            from: p3Chain,
            configuration: configuration,
            session: session
        )
        
        XCTAssert(dChain.indexid == p3Chain.indexid)
        XCTAssert(dChain != p3Chain)
        XCTAssert(dChain.participantCount == 2)
        XCTAssert(dChain.participantTreasureIds.first == p1.indexid)
        XCTAssert(dChain.participantTreasureIds.last == p3.indexid)
        XCTAssert(!dChain.participantTreasureIds.contains(p2.indexid))
        
        return
        
    }
    
}
