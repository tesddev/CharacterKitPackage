//
//  ModelTests.swift
//
//
//  Created by Tes on 01/03/2025.
//

import Foundation
import XCTest
@testable import CharacterKit

final class ModelTests: XCTestCase {
    func testCharacterEquality() {
        // Given
        let location1 = Location(name: "Earth", url: "https://example.com/earth")
        let location2 = Location(name: "Earth", url: "https://example.com/earth")
        
        let character1 = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: location1,
            location: location1,
            image: "https://example.com/rick.jpg",
            episode: ["https://example.com/episode/1"],
            url: "https://example.com/character/1",
            created: "2017-11-04T18:48:46.250Z"
        )
        
        let character2 = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: location2,
            location: location2,
            image: "https://example.com/rick.jpg",
            episode: ["https://example.com/episode/1"],
            url: "https://example.com/character/1",
            created: "2017-11-04T18:48:46.250Z"
        )
        
        let character3 = Character(
            id: 2,
            name: "Morty",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: location1,
            location: location1,
            image: "https://example.com/morty.jpg",
            episode: ["https://example.com/episode/1"],
            url: "https://example.com/character/2",
            created: "2017-11-04T18:50:21.651Z"
        )
        
        // When & Then
        XCTAssertEqual(character1, character2, "Characters with the same ID should be equal")
        XCTAssertNotEqual(character1, character3, "Characters with different IDs should not be equal")
    }
    
    func testLocationEquality() {
        // Given
        let location1 = Location(name: "Earth", url: "https://example.com/earth")
        let location2 = Location(name: "Earth", url: "https://example.com/earth")
        let location3 = Location(name: "Mars", url: "https://example.com/mars")
        
        // When & Then
        XCTAssertEqual(location1, location2, "Locations with the same name and URL should be equal")
        XCTAssertNotEqual(location1, location3, "Locations with different names should not be equal")
    }
    
    func testAPIResponseDecoding() throws {
        // Given
        let jsonData = """
        {
            "info": {
                "count": 826,
                "pages": 42,
                "next": "https://rickandmortyapi.com/api/character?page=2",
                "prev": null
            },
            "results": [
                {
                    "id": 1,
                    "name": "Rick Sanchez",
                    "status": "Alive",
                    "species": "Human",
                    "type": "",
                    "gender": "Male",
                    "origin": {
                        "name": "Earth",
                        "url": "https://rickandmortyapi.com/api/location/1"
                    },
                    "location": {
                        "name": "Earth",
                        "url": "https://rickandmortyapi.com/api/location/20"
                    },
                    "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    "episode": [
                        "https://rickandmortyapi.com/api/episode/1"
                    ],
                    "url": "https://rickandmortyapi.com/api/character/1",
                    "created": "2017-11-04T18:48:46.250Z"
                }
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let response = try decoder.decode(APIResponse<Character>.self, from: jsonData)
        
        // Then
        XCTAssertEqual(response.info.count, 826)
        XCTAssertEqual(response.info.pages, 42)
        XCTAssertEqual(response.info.next, "https://rickandmortyapi.com/api/character?page=2")
        XCTAssertNil(response.info.prev)
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results[0].id, 1)
        XCTAssertEqual(response.results[0].name, "Rick Sanchez")
    }
}
