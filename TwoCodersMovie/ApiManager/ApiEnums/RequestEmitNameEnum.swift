//
//  RequestEmitNameEnum.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//
import Foundation
import SwiftyJSON

enum RequestEmitNameEnum {
    case discover
    case movieDetails(movieId:Int)
    case searchMovie
        
    var description:String {
        switch self {
        case .discover:
            return "discover/movie"
        case .movieDetails(let movieId):
            return "movie/\(movieId)"
        case .searchMovie:
            return ""
        }
    }
}

import SwiftUI
import Combine

enum DataFetchPhase<T> {
    case empty
    case loading
    case success(T)
    case error(Error)
}

struct FetchTaskToken: Equatable {
    let token: Date
} 
