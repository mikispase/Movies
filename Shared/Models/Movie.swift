//
//  Movie.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import Foundation
import SwiftyJSON
import SwiftData

@Model
class Movie: Codable, Identifiable {
    // MARK: - Properties
    @Attribute(.unique)
    var id: Int
    var customId: String?
    var title: String?
    var originalTitle: String?
    var overview: String?
    var releaseDate: String?
    var posterPath: String?
    var backdropPath: String?
    var originalLanguage: String?
    var popularity: Double?
    var voteAverage: Double?
    var voteCount: Int?
    var isAdult: Bool?
    var hasVideo: Bool?
    var isSoftcore: Bool?
    var genreIds: [Int]?
    var myFavorite:Bool = false

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case customId
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case isAdult = "adult"
        case hasVideo = "video"
        case isSoftcore = "softcore"
        case genreIds = "genre_ids"
        case myFavorite = "myFavorite"

    }

    // MARK: - SwiftyJSON Initializer
    init(json: JSON) {
        id = json["id"].intValue
        customId = UUID().uuidString
        title = json["title"].string
        originalTitle = json["original_title"].string
        overview = json["overview"].string
        releaseDate = json["release_date"].string
        posterPath = json["poster_path"].string
        backdropPath = json["backdrop_path"].string
        originalLanguage = json["original_language"].string
        popularity = json["popularity"].double
        voteAverage = json["vote_average"].double
        voteCount = json["vote_count"].int
        isAdult = json["adult"].bool
        hasVideo = json["video"].bool
        isSoftcore = json["softcore"].bool
        genreIds = json["genre_ids"].arrayObject as? [Int]
    }

    // MARK: - Codable (Decodable)
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        customId = try container.decodeIfPresent(String.self, forKey: .customId)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        isAdult = try container.decodeIfPresent(Bool.self, forKey: .isAdult)
        hasVideo = try container.decodeIfPresent(Bool.self, forKey: .hasVideo)
        isSoftcore = try container.decodeIfPresent(Bool.self, forKey: .isSoftcore)
        genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds)
        myFavorite = try container.decodeIfPresent(Bool.self, forKey: .myFavorite) ?? false
    }

    // MARK: - Codable (Encodable)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(customId, forKey: .customId)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(originalTitle, forKey: .originalTitle)
        try container.encodeIfPresent(overview, forKey: .overview)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        try container.encodeIfPresent(backdropPath, forKey: .backdropPath)
        try container.encodeIfPresent(originalLanguage, forKey: .originalLanguage)
        try container.encodeIfPresent(popularity, forKey: .popularity)
        try container.encodeIfPresent(voteAverage, forKey: .voteAverage)
        try container.encodeIfPresent(voteCount, forKey: .voteCount)
        try container.encodeIfPresent(isAdult, forKey: .isAdult)
        try container.encodeIfPresent(hasVideo, forKey: .hasVideo)
        try container.encodeIfPresent(isSoftcore, forKey: .isSoftcore)
        try container.encodeIfPresent(genreIds, forKey: .genreIds)
        try container.encodeIfPresent(myFavorite, forKey: .myFavorite)
    }

    var posterImage: URL? {
        if let posterPath = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w200/\(posterPath)")
        }
        return nil
    }
    
    var poster780Image: URL? {
        if let posterPath = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w780/\(posterPath)")
        }
        return nil
    }
}
