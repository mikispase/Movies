//
//  CustomError.swift
//  TwoCodersMovie
//
//  Created by Dimitar Spasovski on 06/05/2026.
//

enum CustomError: Error {
    case userNotAuthenticated
    case invalidCredentials
    case invalidResponse
    case networkError(Error)
    case internalError
    case other(String)
}
