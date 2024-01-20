//
//  MusicModel.swift
//  SameSpaceMusicsApp
//
//  Created by Rahul Vishwakarma on 20/01/24.
//

import Foundation


// MARK: - SongsModel
struct MusicModel: Codable {
    let data: [MusicModelElement]
}

// MARK: - Datum
struct MusicModelElement: Codable {
    let id: Int
    let status: String
    let sort: JSONNull?
    let userCreated, dateCreated, userUpdated, dateUpdated: String
    let name, artist, accent, cover: String
    let topTrack: Bool
    let url: String

    enum CodingKeys: String, CodingKey {
        case id, status, sort
        case userCreated = "user_created"
        case dateCreated = "date_created"
        case userUpdated = "user_updated"
        case dateUpdated = "date_updated"
        case name, artist, accent, cover
        case topTrack = "top_track"
        case url
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {}
    
    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
