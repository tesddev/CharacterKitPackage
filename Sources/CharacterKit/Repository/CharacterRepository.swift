//
//  CharacterRepository.swift
//
//
//  Created by Tes on 01/03/2025.
//

import Foundation

/// Protocol defining character repository operations
public protocol CharacterRepositoryProtocol {
    /// Fetches a list of characters from the API
    /// - Parameter completion: A closure to be called when the operation completes
    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void)
    
    /// Fetches a single character by ID
    /// - Parameters:
    ///   - id: The character ID
    ///   - completion: A closure to be called when the operation completes
    func fetchCharacter(id: Int, completion: @escaping (Result<Character, Error>) -> Void)
}

/// Repository for fetching and managing character data
public class CharacterRepository: CharacterRepositoryProtocol {
    private let networkManager: NetworkManaging
    private let baseURL = "https://rickandmortyapi.com/api"
    
    /// Creates a new CharacterRepository instance
    /// - Parameter networkManager: The network manager to use for API requests
    public init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    /// Fetches a list of characters from the API
    /// - Parameter completion: A closure to be called when the operation completes
    public func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        let url = "\(baseURL)/character"
        
        networkManager.fetch(from: url) { (result: Result<APIResponse<Character>, NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetches a single character by ID
    /// - Parameters:
    ///   - id: The character ID
    ///   - completion: A closure to be called when the operation completes
    public func fetchCharacter(id: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        let url = "\(baseURL)/character/\(id)"
        
        networkManager.fetch(from: url) { (result: Result<Character, NetworkError>) in
            switch result {
            case .success(let character):
                completion(.success(character))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
