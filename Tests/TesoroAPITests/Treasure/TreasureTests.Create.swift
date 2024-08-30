//
//  File.swift
//  
//
//  Created by Hugh on 24/8/2024.
//

import Foundation
@testable import TesoroAPI


extension TreasureTests {
    
    func testCreateTreasure() async throws {
        
        let configuration = TestConfiguration()
        
        let _ = try await Treasure.create(
            configuration: configuration,
            session: .testSession,
            message: """
Test treasure text
""",
            location: .testLocation
        )

        return
        
    }
    
}
