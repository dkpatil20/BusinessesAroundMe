//
//  NetworkSessionType.swift
//  

import Foundation
public protocol NetworkSession {
    func call<E: ErrorType>(_ request: Requestable, errorType: E.Type, then completionHandler: @escaping ((Result<Data, Error>) -> Void)) -> URLSessionDataTask?
}

public protocol Errorable: Error {
    var errorDescription: String { get }
}

public typealias ErrorType = Errorable & Decodable
