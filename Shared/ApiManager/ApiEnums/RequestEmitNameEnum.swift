//
//  RequestEmitNameEnum.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//
import Foundation
import SwiftyJSON
import Combine

enum SearcTypeEnum {
    case movie
    case series
}
enum DetailsTypeEnum {
    case movie(movieId:Int)
    case series(series:Int)
}

enum RequestEmitNameEnum {
    case discover
    case details(DetailsTypeEnum)
    case searchMovie(SearcTypeEnum)

    var description: String {
        switch self {
        case .discover:
            return "discover/movie"
        case .details(let type):
            switch type {
            case .movie(let movieId):
                return "movie/\(movieId)"
            case .series(let seriesId):
                return "tv/\(seriesId)"
            }
        case .searchMovie(let type):
            switch type {
            case .movie:
                return "search/movie"
            case .series:
                return "search/tv"
            }
        }
    }
}

enum DataFetchPhase<T> {
    case empty
    case loading
    case success(T)
    case error(Error)
}

struct FetchTaskToken: Equatable {
    let token: Date
}
