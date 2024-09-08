//
//  File.swift
//  
//
//  Created by Hugh on 21/8/2024.
//

import Foundation


public struct TesoroError: Error {
    
    public let clientFacingFriendlyMessage: String
    
    static let notImplemented: Self = .init(
        clientFacingFriendlyMessage: """
The requested function is not yet implemented
"""
    )
    
    static let inconsistentState: Self = .init(
        clientFacingFriendlyMessage: """
The app has entered an inconsistent state, and may not function properly
"""
    )

    static let signatureFormationFailure: Self = .init(
        clientFacingFriendlyMessage: """
The app could not perform a cryptography operation, and has stopped as a \
precaution.
"""
    )
    
}
