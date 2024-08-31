//
//  File.swift
//  
//
//  Created by Hugh on 31/8/2024.
//

import Foundation
import XCTest
@testable import TesoroAPI


extension TreasureTests {
    
    func testDeleteTreasure() async throws -> Void {
        
        let configuration = TestConfiguration()
        
        let specimen = try await Treasure.create(
            configuration: TestConfiguration(),
            session: .fromCommandLine(),
            message: "For deletion",
            location: .testLocation
        )
        
        let retrievedSpecimen = try await Treasure.retrieve(
            configuration: configuration,
            session: .fromCommandLine(),
            indexid: specimen.indexid
        )
        
        XCTAssert(retrievedSpecimen.indexid == specimen.indexid)
        
        try await specimen.delete(
            configuration: configuration,
            session: .fromCommandLine()
        )
        
        var didHave404 = false
        do {
            let _ = try await Treasure.retrieve(
                configuration: configuration,
                session: .fromCommandLine(),
                indexid: specimen.indexid
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
    
    
}
