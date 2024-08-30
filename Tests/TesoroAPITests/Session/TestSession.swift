//
//  File.swift
//  
//
//  Created by Hugh on 29/8/2024.
//

import Foundation
import XCTest
@testable import TesoroAPI


final class SessionTests: XCTestCase {
    
    private static var exampleToken: String {
    
        fatalError("""
Removed - need to implement as a command line parameter, now that this repo \
is under public source control.
""")
        
    }
    
    func testCreateAppleIdSession() async throws -> Void {
        
        let _ = try await Session.create(
            configuration: TestConfiguration(),
            appleIdCredentialToken: Self.exampleToken,
            name: nil
        )
        
        return
        
    }
    
}
 
