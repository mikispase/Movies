import Foundation
import SwiftyJSON

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