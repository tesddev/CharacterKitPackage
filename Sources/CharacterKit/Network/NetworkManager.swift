//
//  NetworkManager.swift
//
//
//  Created by Tes on 01/03/2025.
//

import Foundation

/// Defines errors that can occur during network operations
public enum NetworkError: Error {
    /// The URL is invalid
    case invalidURL
    /// The request failed
    case requestFailed(Error)
    /// The response is invalid
    case invalidResponse
    /// Unable to decode the data
    case decodingFailed(Error)
}

/// A protocol defining network operations
public protocol NetworkManaging {
    /// Fetches data from a URL and decodes it to the specified type
    /// - Parameters:
    ///   - url: The URL to fetch data from
    ///   - completion: A closure to be called when the operation completes
    func fetch<T: Decodable>(from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void)
    
    /// Fetches data from a URL string and decodes it to the specified type
    /// - Parameters:
    ///   - urlString: The URL string to fetch data from
    ///   - completion: A closure to be called when the operation completes
    func fetch<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void)
}

/// Manages network operations for the app
public class NetworkManager: NetworkManaging {
    private let session: URLSession
    
    /// Creates a new NetworkManager instance
    /// - Parameter session: The URLSession to use for network requests
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetches data from a URL and decodes it to the specified type
    /// - Parameters:
    ///   - url: The URL to fetch data from
    ///   - completion: A closure to be called when the operation completes
    public func fetch<T: Decodable>(from url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        
        task.resume()
    }
    
    /// Fetches data from a URL string and decodes it to the specified type
    /// - Parameters:
    ///   - urlString: The URL string to fetch data from
    ///   - completion: A closure to be called when the operation completes
    public func fetch<T: Decodable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        fetch(from: url, completion: completion)
    }
}
