//
//  File.swift
//  
//
//  Created by Hugh on 27/8/2024.
//

import Foundation


extension Treasure: Equatable {
    
    // TODO: Account for updates via an .updated property
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return (
            lhs.indexid == rhs.indexid
            && lhs.retrieved == rhs.retrieved
        )
    }
    
}
