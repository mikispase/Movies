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
    case moviewDetails
    case searchMovie
        
    var description:String {
        switch self {
        case .discover:
            return "discover/movie"
        case .moviewDetails:
            return ""
        case .searchMovie:
            return ""
        }
    }
}
