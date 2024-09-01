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
    
}
