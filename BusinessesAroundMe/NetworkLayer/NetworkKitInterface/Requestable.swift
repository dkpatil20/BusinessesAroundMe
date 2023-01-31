//
//  Requestable.swift
//

import Foundation

/// This is equivalent to Base Service
public protocol Requestable {
    var urlType: URLType { get }
    var requestType: HTTPRequestType { get }
    var header: [String: String]? { get }
    var configuration: RequestConfigurableType { get }
    var urlRequest: URLRequest? { get }
}

extension Requestable {
    var configuration: RequestConfigurableType {
        return RequestConfigurable()
    }
}

public protocol CallBackThread {
    var callbackDispatchQueue: DispatchQueue { get }
}
