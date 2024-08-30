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
        
        /*let _ = try await Treasure.create(
            configuration: configuration,
            session: .fromCommandLine(),
            message: """
Test treasure text
""",
            location: .testLocation
        )*/
        
        let _ = try await Treasure.create(
            configuration: configuration,
            session: .fromCommandLine(),
            message: "Test treasure known real location",
            location: .init(
                latitude: -33.893450686777925,
                longitude: 151.2123368378304,
                altitude: 33.708626
            )
        )

        return
        
    }
    
}
