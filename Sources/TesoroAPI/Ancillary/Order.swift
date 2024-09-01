//
//  File.swift
//  
//
//  Created by Hugh on 1/9/2024.
//

import Foundation


public enum Order: String, Identifiable, Hashable, Equatable, CaseIterable {
    
    case ascending = "ascending"
    case descending = "descending"
    
    public var id: String { return self.rawValue }

}
