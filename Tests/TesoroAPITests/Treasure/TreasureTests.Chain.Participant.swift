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
        
        let p2r = try await p2.refresh(
            configuration: configuration,
            session: session
        )
        
        XCTAssert(p2r.chainPosition == nil)
        
        let p3r = try await p3.refresh(
            configuration: configuration,
            session: session
        )
        
        XCTAssert(p3r.chainPosition != nil)
        XCTAssert(p3r.chainPosition?.chainId == chain.indexid)
        XCTAssert(p3r.chainPosition?.sequence == 2)
        
        return
        
    }
    
    func testRetrieveTreasuresFilteringByChainParticipation()
        async throws -> Void {
        
        let start = Date()
        
        let configuration = TestConfiguration()
        let session = Session.fromCommandLine()
        
        let p1 = try await Treasure.create(
            configuration: configuration,
            session: session,
            message: "Test treasure for Chain filtering",
            location: .randomForTesting()
        )
        
        let p2 = try await Treasure.create(
            configuration: configuration,
            session: session,
            message: "Test treasure for Chain filtering",
            location: .randomForTesting()
        )
        
        let chain = try await Treasure.Chain.create(
            configuration: configuration,
            session: session,
            participants: [p1, p2]
        )
        
        let _ = try await Treasure.create(
            configuration: configuration,
            session: session,
            message: "Test treasure for Chain filtering",
            location: .randomForTesting()
        )
        
        let noFilter = try await Treasure.retrieveMany(
            configuration: configuration,
            session: session,
            createdAtOrAfter: start
        )
        
        XCTAssert(noFilter.count == 3)
        
        let withChain = try await Treasure.retrieveMany(
            configuration: configuration,
            session: session,
            createdAtOrAfter: start,
            chainParticipation: .participatingInAnyChain
        )
        
        XCTAssert(withChain.count == 2)
        
        let withoutChain = try await Treasure.retrieveMany(
            configuration: configuration,
            session: session,
            createdAtOrAfter: start,
            chainParticipation: .notParticipatingInAnyChain
        )
        
        XCTAssert(withoutChain.count == 1)
        
        let specificChain = try await Treasure.retrieveMany(
            configuration: configuration,
            session: session,
            chainParticipation: .participatingInASpecificChain(chain)
        )
        
        print("Specific chain: \(specificChain.count)")
        XCTAssert(specificChain.count == 2)
        
        return
        
    }
    
}
