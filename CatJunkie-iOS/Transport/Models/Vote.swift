//
//  Vote
//  CatJunkie-iOS
//
//  Created by e.vanags on 21/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation

typealias Votes = [Vote]

struct Vote: Codable, Equatable {

    enum `Type`: Int {
        case down, up
    }

    let id: String
    let userId: String
    let type: Type

    /// Initialize encodable `Vote` model.
    ///
    /// - Parameters:
    ///   - id: Unique identifier of cat image.
    ///   - userId: Unique identifer of user (used to cast and retrieve votes).
    ///   - type: Indicator of whether to increase or decrese vote count.
    init(id: String, userId: String, _ type: Type) {
        self.id = id
        self.userId = userId
        self.type = type
    }

    private enum CodingKeys: String, CodingKey {
        case id = "image_id"
        case userId = "sub_id"
        case type = "value"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        type = Type(rawValue: try container.decode(Int.self, forKey: .type)) ?? .up
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(type.rawValue, forKey: .type)
    }
}
