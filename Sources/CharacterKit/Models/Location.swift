//
//  Location.swift
//  
//
//  Created by Tes on 01/03/2025.
//

import Foundation

public struct Location: Codable, Equatable {
    /// The name of the location
    public let name: String
    /// URL to the location's endpoint
    public let url: String
    
    /// Creates a new Location instance
    /// - Parameters:
    ///   - name: The name of the location
    ///   - url: URL to the location's endpoint
    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
