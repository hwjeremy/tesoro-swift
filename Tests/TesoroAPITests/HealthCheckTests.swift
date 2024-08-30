//
//  File.swift
//  
//
//  Created by Hugh on 28/8/2024.
//

import Foundation
import XCTest
import TesoroAPI

final class HealthCheckTests: XCTestCase {
    
    func testPerformHealthCheck() async throws -> Void {
        
        let check = try await HealthCheck.retrieve(
            configuration: TestConfiguration(),
            session: nil
        )
        
        guard check.created < Date() else { XCTFail(); return }
        
        return
        
    }
    
    
}
