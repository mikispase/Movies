//
//  DetailsObject.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import Foundation
import SwiftyJSON

// MARK: - MovieDetails
class DetailsObject: Codable, Identifiable {
    var homepage: String?
    var voteCount: Int?
    var overview: String?
    var id: Int?
    var backdropPath: String?
    var productionCountries: [ProductionCountry]?
    var voteAverage: Double?
    var posterPath: String?
    var popularity: Double?
    var budget: Int?
    var originCountry: [String]?
    var belongsToCollection: Collection?
    var adult: Bool?
    var tagline: String?
    var spokenLanguages: [SpokenLanguage]?
    var productionCompanies: [ProductionCompany]?
    var softcore: Bool?
    var releaseDate: String?
    var imdbID: String?
    var originalLanguage: String?
    var title: String?
    var runtime: Int?
    var genres: [Genre]?
    var originalTitle: String?
    var video: Bool?
    var revenue: Int?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case homepage
        case voteCount = "vote_count"
        case overview
        case id
        case backdropPath = "backdrop_path"
        case productionCountries = "production_countries"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case popularity
        case budget
        case originCountry = "origin_country"
        case belongsToCollection = "belongs_to_collection"
        case adult
        case tagline
        case spokenLanguages = "spoken_languages"
        case productionCompanies = "production_companies"
        case softcore
        case releaseDate = "release_date"
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case title
        case runtime
        case genres
        case originalTitle = "original_title"
        case video
        case revenue
        case status
    }

    // MARK: - Decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        productionCountries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries)
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
        belongsToCollection = try container.decodeIfPresent(Collection.self, forKey: .belongsToCollection)
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        spokenLanguages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages)
        productionCompanies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies)
        softcore = try container.decodeIfPresent(Bool.self, forKey: .softcore)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        video = try container.decodeIfPresent(Bool.self, forKey: .video)
        revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        status = try container.decodeIfPresent(String.self, forKey: .status)
    }

    // MARK: - Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(homepage, forKey: .homepage)
        try container.encodeIfPresent(voteCount, forKey: .voteCount)
        try container.encodeIfPresent(overview, forKey: .overview)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(backdropPath, forKey: .backdropPath)
        try container.encodeIfPresent(productionCountries, forKey: .productionCountries)
        try container.encodeIfPresent(voteAverage, forKey: .voteAverage)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        try container.encodeIfPresent(popularity, forKey: .popularity)
        try container.encodeIfPresent(budget, forKey: .budget)
        try container.encodeIfPresent(originCountry, forKey: .originCountry)
        try container.encodeIfPresent(belongsToCollection, forKey: .belongsToCollection)
        try container.encodeIfPresent(adult, forKey: .adult)
        try container.encodeIfPresent(tagline, forKey: .tagline)
        try container.encodeIfPresent(spokenLanguages, forKey: .spokenLanguages)
        try container.encodeIfPresent(productionCompanies, forKey: .productionCompanies)
        try container.encodeIfPresent(softcore, forKey: .softcore)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encodeIfPresent(imdbID, forKey: .imdbID)
        try container.encodeIfPresent(originalLanguage, forKey: .originalLanguage)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(runtime, forKey: .runtime)
        try container.encodeIfPresent(genres, forKey: .genres)
        try container.encodeIfPresent(originalTitle, forKey: .originalTitle)
        try container.encodeIfPresent(video, forKey: .video)
        try container.encodeIfPresent(revenue, forKey: .revenue)
        try container.encodeIfPresent(status, forKey: .status)
    }

    // MARK: - SwiftyJSON
    init(json: JSON) {
        homepage = json["homepage"].string
        voteCount = json["vote_count"].int
        overview = json["overview"].string
        id = json["id"].int
        backdropPath = json["backdrop_path"].string
        productionCountries = json["production_countries"].arrayValue.map { ProductionCountry(json: $0) }
        voteAverage = json["vote_average"].double
        posterPath = json["poster_path"].string
        popularity = json["popularity"].double
        budget = json["budget"].int
        originCountry = json["origin_country"].arrayValue.map { $0.stringValue }
        belongsToCollection = json["belongs_to_collection"].isEmpty ?
        nil : Collection(json: json["belongs_to_collection"])
        adult = json["adult"].bool
        tagline = json["tagline"].string
        spokenLanguages = json["spoken_languages"].arrayValue.map { SpokenLanguage(json: $0) }
        productionCompanies = json["production_companies"].arrayValue.map { ProductionCompany(json: $0) }
        softcore = json["softcore"].bool
        releaseDate = json["release_date"].string
        imdbID = json["imdb_id"].string
        originalLanguage = json["original_language"].string
        title = json["title"].string
        runtime = json["runtime"].int
        genres = json["genres"].arrayValue.map { Genre(json: $0) }
        originalTitle = json["original_title"].string
        video = json["video"].bool
        revenue = json["revenue"].int
        status = json["status"].string
    }

    var posterImage: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w780\(posterPath ?? "")")
    }
}

class ProductionCountry: Codable, Identifiable {
    var name: String?
    var iso: String?

    enum CodingKeys: String, CodingKey {
        case name
        case iso = "iso_3166_1"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        iso = try container.decodeIfPresent(String.self, forKey: .iso)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(iso, forKey: .iso)
    }

    init(json: JSON) {
        name = json["name"].string
        iso = json["iso_3166_1"].string
    }

    func flagEmoji(for countryCode: String) -> String {
        let base: UInt32 = 127397
        var sxx = ""
        for uniCode in countryCode.uppercased().unicodeScalars {
            guard let scalar = UnicodeScalar(base + uniCode.value) else { continue }
            sxx.unicodeScalars.append(scalar)
        }
        return sxx
    }
}

class Collection: Codable {
    var backdropPath: String?
    var id: Int?
    var posterPath: String?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case posterPath = "poster_path"
        case name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(backdropPath, forKey: .backdropPath)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        try container.encodeIfPresent(name, forKey: .name)
    }

    init(json: JSON) {
        backdropPath = json["backdrop_path"].string
        id = json["id"].int
        posterPath = json["poster_path"].string
        name = json["name"].string
    }
}

class SpokenLanguage: Codable {
    var iso: String?
    var name: String?
    var englishName: String?

    enum CodingKeys: String, CodingKey {
        case iso = "iso_639_1"
        case name
        case englishName = "english_name"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        iso = try container.decodeIfPresent(String.self, forKey: .iso)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        englishName = try container.decodeIfPresent(String.self, forKey: .englishName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(iso, forKey: .iso)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(englishName, forKey: .englishName)
    }

    init(json: JSON) {
        iso = json["iso_639_1"].string
        name = json["name"].string
        englishName = json["english_name"].string
    }
}

class ProductionCompany: Codable {
    var logoPath: String?
    var originCountry: String?
    var id: Int?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case originCountry = "origin_country"
        case id
        case name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        logoPath = try container.decodeIfPresent(String.self, forKey: .logoPath)
        originCountry = try container.decodeIfPresent(String.self, forKey: .originCountry)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(logoPath, forKey: .logoPath)
        try container.encodeIfPresent(originCountry, forKey: .originCountry)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(name, forKey: .name)
    }

    init(json: JSON) {
        logoPath = json["logo_path"].string
        originCountry = json["origin_country"].string
        id = json["id"].int
        name = json["name"].string
    }
}

class Genre: Codable {
    var name: String?
    var id: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case id
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(id, forKey: .id)
    }

    init(json: JSON) {
        name = json["name"].string
        id = json["id"].int
    }
}
