import SwiftyJSON
import Foundation

struct CreditsResponse {
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]

    init(json: JSON) {
        self.id = json["id"].intValue
        self.cast = json["cast"].arrayValue.map { CastMember(json: $0) }
        self.crew = json["crew"].arrayValue.map { CrewMember(json: $0) }
    }
}

struct CastMember {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    let order: Int

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.character = json["character"].stringValue
        self.profilePath = json["profile_path"].string
        self.order = json["order"].intValue
    }
    
    var posterImage: URL? {
        if let profilePath = profilePath {
            return URL(string: "https://image.tmdb.org/t/p/w200\(profilePath)")
        }
        return nil
    }
}

struct CrewMember {
    let id: Int
    let name: String
    let job: String
    let department: String

    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.job = json["job"].stringValue
        self.department = json["department"].stringValue
    }
}
