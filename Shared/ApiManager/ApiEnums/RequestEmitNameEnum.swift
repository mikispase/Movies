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

enum CreditEnum {
    case movie(id:Int)
    case series(id:Int)
}

enum DetailsTypeEnum {
    case movie(movieId:Int)
    case series(series:Int)
    case credit(CreditEnum)
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
            case .credit(let type):
                switch type {
                case .movie(let id):
                    return "movie/\(id)/credits"
                case .series(let id):
                    return "tv/\(id)/credits"
                }
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
