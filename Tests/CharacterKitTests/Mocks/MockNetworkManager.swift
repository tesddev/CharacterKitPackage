//
//  MockNetworkManager.swift
//
//
//  Created by Tes on 01/03/2025.
//

import Foundation
@testable import CharacterKit

class MockNetworkManager: NetworkManaging {
    var fetchFromURLCalled = false
    var fetchFromStringCalled = false
    var urlPassed: URL?
    var stringPassed: String?
    var resultToReturn: Any?
    var errorToReturn: NetworkError?
    
    func fetch<T: Decodable>(from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        fetchFromURLCalled = true
        urlPassed = url
        
        if let error = errorToReturn {
            completion(.failure(error))
        } else if let result = resultToReturn as? T {
            completion(.success(result))
        }
    }
    
    func fetch<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        fetchFromStringCalled = true
        stringPassed = urlString
        
        if let url = URL(string: urlString) {
            fetch(from: url, completion: completion)
        } else {
            completion(.failure(.invalidURL))
        }
    }
}
