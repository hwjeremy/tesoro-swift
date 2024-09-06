//
//  File.swift
//  
//
//  Created by Hugh on 31/8/2024.
//

import Foundation
@testable import TesoroAPI
import XCTest


extension TreasureTests {
    
    func testRetrieveManyTreasures() async throws {
        
        let configuration = TestConfiguration()
        let session = Session.fromCommandLine()

        let treasures = try await Treasure.retrieveMany(
            configuration: configuration,
            session: .fromCommandLine(),
            author: .session(session)
        )
        
        XCTAssert(treasures.count > 0)
        
        for treasure in treasures {
            XCTAssert(treasure.author.agentId == session.agentId)
        }

        return
        
    }
    
    func testRetrieveTreasuresInOrder() async throws {
        
        let configuration = TestConfiguration()
        let session = Session.fromCommandLine()
        
        let treasures = try await Treasure.retrieveMany(
            configuration: configuration,
            session: .fromCommandLine(),
            author: .session(session),
            order: .ascending,
            orderBy: .created,
            limit: 10,
            offset: 0
        )
        
        guard let firstDate = treasures.first?.created else {
            XCTFail(); return
        }
        
        XCTAssert(treasures.count > 1)
        
        let earliest: Date = treasures.reduce(firstDate) { partial, treasure in
            if treasure.created < partial { return treasure.created }
            return partial
        }
        
        let latest: Date = treasures.reduce(firstDate) { partial, treasure in
            if treasure.created > partial { return treasure.created }
            return partial
        }
        
        let earliestFirst = try await Treasure.retrieveMany(
            configuration: configuration,
            session: .fromCommandLine(),
            author: .session(session),
            order: .ascending,
            orderBy: .created,
            limit: 10,
            offset: 0
        )
        
        XCTAssert(earliestFirst.first?.created == earliest)
        XCTAssert(earliestFirst.last?.created == latest)
        
        let latestFirst = try await Treasure.retrieveMany(
            configuration: configuration,
            session: .fromCommandLine(),
            author: .session(session),
            order: .descending,
            orderBy: .created,
            limit: 10,
            offset: 0
        )

        XCTAssert(latestFirst.first?.created != latest)
        XCTAssert(latestFirst.last?.created != earliest)
        
        return
        
    }
    
    func testRetrieveTreasuresExcludingAuthor() async throws {
        
        let configuration = TestConfiguration()
        let session = Session.fromCommandLine()
        
        let treasures = try await Treasure.retrieveMany(
            configuration: configuration,
            session: session,
            author: .session(session)
        )
        
        if treasures.count < 1 {
            
            let _ = try await Treasure.create(
                configuration: configuration,
                session: session,
                message: "Test treasure for discovery",
                location: .randomForTesting()
            )
            
            guard try await Treasure.retrieveMany(
                configuration: configuration,
                session: session,
                author: .session(session)
            ).first != nil else { XCTFail(); return }
            
        }
        
        let shouldBeEmpty = try await Treasure.retrieveMany(
            configuration: configuration,
            session: session,
            author: .session(session),
            excludeAuthor: .session(session)
        )
        
        XCTAssert(shouldBeEmpty.count == 0)
        
        return
        
    }
    
    func testRetrieveTreasuresByDistance() async throws {
        
        let configuration = TestConfiguration()
        let session = Session.fromCommandLine()
        
        let treasures = try await Treasure.retrieveMany(
            configuration: configuration,
            session: session,
            relativeTo: Treasure.Location.testLocation,
            order: .ascending,
            orderBy: .distance,
            limit: 40,
            offset: 0
        )
        
        print(Treasure.Location.testLocation)
        
        guard treasures.count > 1 else { XCTFail(); return }
        
        guard let firstDistance = treasures.first?.distance else {
            XCTFail(); return
        }
        
        XCTAssert(firstDistance <= 0.01)
        
        var previousDistance: Double = 0
        
        for treasure in treasures {
            guard let distance = treasure.distance else { XCTFail(); return }
            guard distance >= previousDistance else { XCTFail(); return }
            previousDistance = distance
            continue
        }
        
        return

    }
    
    func testRetrieveTreasuresDiscoveredBy() async throws {
        
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
        
        let discovered = try await Treasure.retrieveMany(
            configuration: configuration,
            session: session,
            discoveryState: .discoveredBySpecificAgent(.session(session)),
            order: .descending,
            orderBy: .created,
            limit: 1
        )
        
        guard let retrieved = discovered.first else { XCTFail(); return }
        
        XCTAssert(retrieved.indexid == subject.indexid)
        
        return
    }
    
}
