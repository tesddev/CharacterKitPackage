//
//  APIResponse.swift
//  
//
//  Created by Tes on 01/03/2025.
//

import Foundation

/// The response structure from the Rick and Morty API
public struct APIResponse<T: Codable>: Codable {
    /// Information about the API response, including pagination details
    public let info: ResponseInfo
    /// The results returned by the API
    public let results: [T]
    
    /// Creates a new APIResponse instance
    /// - Parameters:
    ///   - info: Information about the response
    ///   - results: The results returned
    public init(info: ResponseInfo, results: [T]) {
        self.info = info
        self.results = results
    }
}

/// Information about the API response, including pagination details
public struct ResponseInfo: Codable {
    /// The total number of results available
    public let count: Int
    /// The number of pages available
    public let pages: Int
    /// URL to the next page (if available)
    public let next: String?
    /// URL to the previous page (if available)
    public let prev: String?
    
    /// Creates a new ResponseInfo instance
    /// - Parameters:
    ///   - count: The total number of results
    ///   - pages: The number of pages
    ///   - next: URL to the next page
    ///   - prev: URL to the previous page
    public init(count: Int, pages: Int, next: String?, prev: String?) {
        self.count = count
        self.pages = pages
        self.next = next
        self.prev = prev
    }
}
