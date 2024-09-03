//
//  File.swift
//  
//
//  Created by Hugh on 27/8/2024.
//

import Foundation


extension Treasure: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("__Treasure__")
        hasher.combine(self.indexid)
        hasher.combine(self.retrieved)
        return
    }

}
