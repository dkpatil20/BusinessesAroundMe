//
//  CustomError.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation

// MARK: - CustomError
struct CustomError: ErrorType {
    let error: NestedError
    var errorDescription: String {
        error.description
    }
}

enum ErrorCode: String, Codable {
    case VALIDATION_ERROR
    case INVALID_REQUEST
    case UNAUTHORIZED_ACCESS_TOKEN
    case TOKEN_INVALID
    case AUTHORIZATION_ERROR
    case NOT_FOUND
    case PAYLOAD_TOO_LARGE
    case TOO_MANY_REQUESTS_PER_SECOND
    case SERVICE_UNAVAILABLE
}

// MARK: - Error
struct NestedError: Codable {
    let code: ErrorCode
    let description: String
    let field, instance: String?
}
