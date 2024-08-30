//
//  File.swift
//  
//
//  Created by Hugh on 24/8/2024.
//

import Foundation
@testable import TesoroAPI


final class TestConfiguration: TesoroAPI.Configuration {
    
    private static let defaultApiEndpoint: String = """
https://amatino.io/tesoro/api
"""
    
    let apiEndpoint: String
    
    init() {
        
        if let configuredEndpoint = TesoroAPI.CommandLine.valueFor(
            key: "api_endpoint"
        ) {
            self.apiEndpoint = configuredEndpoint
        } else {
            self.apiEndpoint = Self.defaultApiEndpoint
        }
        
    }
    
}
