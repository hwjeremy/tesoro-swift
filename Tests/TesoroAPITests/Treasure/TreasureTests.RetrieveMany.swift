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

        let treasures = try await Treasure.retrieveMany(
            configuration: configuration,
            session: .fromCommandLine(),
            author: .session(.fromCommandLine())
        )
        
        XCTAssert(treasures.count > 0)

        return
        
    }
    
}
