//
//  APIRequestable.swift
//  
//

import Foundation

public protocol APIServicable: APIStringServicable, APIDataServicable, APIDecodableServicable, APICancellable {}

public protocol APICancellable {
    func cancel(task: URLSessionDataTask?)
}

public protocol APIStringServicable {
    @discardableResult
    func getString<E: ErrorType>(_ request: Requestable, errorType: E.Type, then completionHandler: @escaping ((Result<String, Error>) -> Void)) -> URLSessionDataTask?
}

public protocol APIDataServicable {
    @discardableResult
    func getData<E: ErrorType>(_ request: Requestable, errorType: E.Type, then completionHandler: @escaping ((Result<Data, Error>) -> Void)) -> URLSessionDataTask?
}

public protocol APIDecodableServicable {
    @discardableResult
    func getDecodableData<T: Decodable, E: ErrorType>(of type: T.Type, errorType: E.Type, request: Requestable, then completionHandler: @escaping ((Result<T, Error>) -> Void)) -> URLSessionDataTask?
}
