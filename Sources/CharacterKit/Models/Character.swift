//
//  Character.swift
//  
//
//  Created by Tes on 01/03/2025.
//

import Foundation

/// Represents a character from the Rick and Morty universe
public struct Character: Identifiable, Codable, Equatable {
    /// The unique identifier of the character
    public let id: Int
    /// The name of the character
    public let name: String
    /// The status of the character (Alive, Dead, or unknown)
    public let status: String
    /// The species of the character
    public let species: String
    /// The type or subspecies of the character
    public let type: String
    /// The gender of the character
    public let gender: String
    /// The character's origin location
    public let origin: Location
    /// The character's last known location
    public let location: Location
    /// URL to the character's image
    public let image: String
    /// List of episodes in which this character appeared
    public let episode: [String]
    /// URL to the character's own endpoint
    public let url: String
    /// Time at which the character was created in the database
    public let created: String
    
    /// Creates a new Character instance
    /// - Parameters:
    ///   - id: The unique identifier
    ///   - name: The name of the character
    ///   - status: The status (Alive, Dead, or unknown)
    ///   - species: The species of the character
    ///   - type: The type or subspecies
    ///   - gender: The gender
    ///   - origin: The origin location
    ///   - location: The last known location
    ///   - image: URL to the character's image
    ///   - episode: Episodes the character appeared in
    ///   - url: URL to the character's endpoint
    ///   - created: Creation timestamp
    public init(
        id: Int,
        name: String,
        status: String,
        species: String,
        type: String,
        gender: String,
        origin: Location,
        location: Location,
        image: String,
        episode: [String],
        url: String,
        created: String
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
    
    public static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}
