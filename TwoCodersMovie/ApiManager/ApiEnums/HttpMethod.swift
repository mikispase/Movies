//
//  HttpMethod.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

import Foundation

enum HttpMethod {
    case get
    case post
    
    var string:String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
