//
//  AppError.swift
//

import Foundation

public struct ErrorResponse: Decodable {
    /// This property is used as a flag to indicate if the account needs to be activated to login
    public var reason: String?
    /// This property is used to redirect user to this web view url if applicable
    public var webViewUrl: String?
    /// This property is used as a header in activation api
    public var token: String?
    
    public init(reason: String? = nil,
                webViewUrl: String? = nil,
                token: String? = nil) {
        self.reason = reason
        self.webViewUrl = webViewUrl
        self.token = token
    }
    
    enum CodingKeys: String, CodingKey {
        case reason = "errReason"
        case webViewUrl
        case token
    }
}
extension NSError: Errorable {
    public var errorDescription: String {
        description
    }
}


public enum AppError: Errorable {
    case network(type: Enums.NetworkError)
    case custom(errorDescription: String?)
    case error(error: ErrorType) // need to override the localizedDescription
    //    case db(type: Enums.DB)
    public class Enums { }
    
    public var errorDescription: String {
        switch self {
        case .network(let type): return type.errorDescription
        case .custom(let errorDescription): return errorDescription ?? ""
        case .error(let error): return error.errorDescription
        }
    }
}

// MARK: - Network Errors
public extension AppError.Enums {
    enum NetworkError: Errorable {
        case unauthorized
        case parsing(dataString: String, description: String)
        case invalidURLRequest
        case dataNotFound
        case custom(errorCode: Int?, errorDescription: String?)
        case error(error: Errorable) // need to override the localizedDescription

        public var errorDescription: String {
            switch self {
            case .unauthorized:
                return "Unauthorized"
            case .parsing(_, let description):
                return "Parsing error: \(description)"
            case .invalidURLRequest:
                return "Invalid URL Request"
            case .dataNotFound:
                return "URL Not Found"
            case .custom(_, let errorDescription):
                return errorDescription ?? ""
            case .error(let error):
                return error.errorDescription
            }
        }
        
        public var errorCode: Int? {
            switch self {
            case .parsing: return nil
            case .invalidURLRequest: return 400
            case .unauthorized: return 401
            case .error(error: let error): return (error as NSError).code
            case .dataNotFound: return 404
            case .custom(let errorCode, _): return errorCode
            }
        }
    }
}
