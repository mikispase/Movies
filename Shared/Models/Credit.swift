import SwiftyJSON
import Foundation
import SwiftData

@Model
class CreditsObject: Codable {
    @Attribute(.unique) var id: Int = 0
    var cast: [CastMember] = []
    var crew: [CrewMember] = []

    init(json: JSON) {
        self.id = json["id"].intValue
        self.cast = json["cast"].arrayValue.map { CastMember(json: $0) }
        self.crew = json["crew"].arrayValue.map { CrewMember(json: $0) }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case cast
        case crew
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.cast = try container.decode([CastMember].self, forKey: .cast)
        self.crew = try container.decode([CrewMember].self, forKey: .crew)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cast, forKey: .cast)
        try container.encode(crew, forKey: .crew)
    }
}

@Model
class CastMember: Codable {
    var id: Int
    var name: String = ""
    var character: String = ""
    var profilePath: String?
    var order: Int = 0

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.character = json["character"].stringValue
        self.profilePath = json["profile_path"].string
        self.order = json["order"].intValue
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
        case order
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.character = try container.decode(String.self, forKey: .character)
        self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
        self.order = try container.decode(Int.self, forKey: .order)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(character, forKey: .character)
        try container.encode(profilePath, forKey: .profilePath)
        try container.encode(order, forKey: .order)
    }

    var posterImage: URL? {
        if let profilePath = profilePath {
            return URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)")
        }
        return nil
    }
}

@Model
class CrewMember: Codable {
    var id: Int
    var name: String = ""
    var job: String = ""
    var department: String = ""

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.job = json["job"].stringValue
        self.department = json["department"].stringValue
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case job
        case department
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.job = try container.decode(String.self, forKey: .job)
        self.department = try container.decode(String.self, forKey: .department)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(job, forKey: .job)
        try container.encode(department, forKey: .department)
    }
}
