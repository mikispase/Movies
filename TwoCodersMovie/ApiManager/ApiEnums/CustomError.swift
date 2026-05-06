enum CustomError: Error {
    case userNotAuthenticated
    case invalidCredentials
    case invalidResponse
    case networkError(Error)
    case internalError
    case other(String)
}