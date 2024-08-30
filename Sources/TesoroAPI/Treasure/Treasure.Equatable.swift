//
//  File.swift
//  
//
//  Created by Hugh on 27/8/2024.
//

import Foundation


extension Treasure: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.indexid == rhs.indexid
    }
    
}
