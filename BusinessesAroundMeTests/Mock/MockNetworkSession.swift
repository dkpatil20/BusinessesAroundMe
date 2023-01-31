//
//  MockNetworkSession.swift
//  BusinessesAroundMeTests
//
//  Created by Dhiraj Patil on 30/01/23.
//

import Foundation
import XCTest
@testable import BusinessesAroundMe

enum ResultType {
    case success(String)
    case failure(String)
}

class MockNetworkSession: NetworkSession {
    var result: ResultType = .failure("")
    
    func call<E>(_ request: Requestable, errorType: E.Type, then completionHandler: @escaping ((Result<Data, Error>) -> Void)) -> URLSessionDataTask? where E : Errorable, E : Decodable {
        switch result {
        case .success(let fileName):
        let response = MockAPIResponseHandler.getResponse(fileName: fileName, response: nil)
        completionHandler(response)
        case .failure(let error):
            let response = MockAPIResponseHandler.getResponse(fileName: error, response: nil)
            let error: Error
            switch response {
            case .success(let data):

                do {
                    let errorResponse = try JSONDecoder().decode(errorType, from: data)
                    error = AppError.network(type: .error(error: errorResponse))
                } catch let err as NSError {
                    error = AppError.network(type: .parsing(dataString: data.prettyPrintedJSON ?? "",
                                                            description: err.description))
                }

            case .failure(let failure):
                error = failure
            }
            completionHandler(.failure(error))
        }
        return nil
    }
}
