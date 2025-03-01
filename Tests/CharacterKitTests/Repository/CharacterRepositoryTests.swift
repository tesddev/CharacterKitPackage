//
//  CharacterRepositoryTests.swift
//
//
//  Created by Tes on 01/03/2025.
//

import Foundation
import XCTest
@testable import CharacterKit

final class CharacterRepositoryTests: XCTestCase {
    func testFetchCharacters() {
        // Given
        let expectation = expectation(description: "Fetch characters")
        let mockNetworkManager = MockNetworkManager()
        let repository = CharacterRepository(networkManager: mockNetworkManager)
        
        let location = Location(name: "Earth", url: "https://example.com/earth")
        let character = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: location,
            location: location,
            image: "https://example.com/rick.jpg",
            episode: ["https://example.com/episode/1"],
            url: "https://example.com/character/1",
            created: "2017-11-04T18:48:46.250Z"
        )
        
        let responseInfo = ResponseInfo(count: 1, pages: 1, next: nil, prev: nil)
        let apiResponse = APIResponse(info: responseInfo, results: [character])
        mockNetworkManager.resultToReturn = apiResponse
        
        // When
        repository.fetchCharacters { result in
            // Then
            switch result {
            case .success(let characters):
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters[0].id, 1)
                XCTAssertEqual(characters[0].name, "Rick")
                XCTAssertTrue(mockNetworkManager.fetchFromStringCalled)
                XCTAssertEqual(mockNetworkManager.stringPassed, "https://rickandmortyapi.com/api/character")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchCharactersFailure() {
        // Given
        let expectation = expectation(description: "Fetch characters with failure")
        let mockNetworkManager = MockNetworkManager()
        let repository = CharacterRepository(networkManager: mockNetworkManager)
        
        mockNetworkManager.errorToReturn = .invalidURL
        
        // When
        repository.fetchCharacters { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, .invalidURL)
                XCTAssertTrue(mockNetworkManager.fetchFromStringCalled)
                XCTAssertEqual(mockNetworkManager.stringPassed, "https://rickandmortyapi.com/api/character")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchCharacter() {
        // Given
        let expectation = expectation(description: "Fetch character by ID")
        let mockNetworkManager = MockNetworkManager()
        let repository = CharacterRepository(networkManager: mockNetworkManager)
        
        let location = Location(name: "Earth", url: "https://example.com/earth")
        let character = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: location,
            location: location,
            image: "https://example.com/rick.jpg",
            episode: ["https://example.com/episode/1"],
            url: "https://example.com/character/1",
            created: "2017-11-04T18:48:46.250Z"
        )
        
        mockNetworkManager.resultToReturn = character
        
        // When
        repository.fetchCharacter(id: 1) { result in
            // Then
            switch result {
            case .success(let fetchedCharacter):
                XCTAssertEqual(fetchedCharacter.id, 1)
                XCTAssertEqual(fetchedCharacter.name, "Rick")
                XCTAssertTrue(mockNetworkManager.fetchFromStringCalled)
                XCTAssertEqual(mockNetworkManager.stringPassed, "https://rickandmortyapi.com/api/character/1")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchCharacterFailure() {
        // Given
        let expectation = expectation(description: "Fetch character by ID with failure")
        let mockNetworkManager = MockNetworkManager()
        let repository = CharacterRepository(networkManager: mockNetworkManager)
        
        mockNetworkManager.errorToReturn = .invalidURL
        
        // When
        repository.fetchCharacter(id: 1) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, .invalidURL)
                XCTAssertTrue(mockNetworkManager.fetchFromStringCalled)
                XCTAssertEqual(mockNetworkManager.stringPassed, "https://rickandmortyapi.com/api/character/1")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
