//
//  File.swift
//  
//
//  Created by Hugh on 4/9/2024.
//

import Foundation
import TesoroAPI
import XCTest

extension TreasureTests {
    
    func testFindNearestUndiscovered() async throws -> Void {
        
        let session = Session.fromCommandLine()
        
        // For expediency, depend on cruft built up in the target database
        guard let result = try await Treasure.findClosestUndiscovered(
            relativeTo: .example,
            configuration: TestConfiguration(),
            session: session
        ) else { XCTFail(); return }
        
        guard let ras = result.retrievingAgentState else {
            XCTFail(); return
        }
        
        XCTAssert(result.hasBeenDiscovered(by: session) == false)
        XCTAssert(ras.retrievingAgentId == session.agentId)
        
        return
        
    }
    
}
