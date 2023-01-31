//
//  File.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import Foundation
@testable import BusinessesAroundMe

final class MockAPIResponseHandler {
    
    static func getResponse(fileName: String, response: HTTPURLResponse?) -> Result<Data, Error> {
       
        // Check if the file exists
        guard let pathString = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            let dataNotFoundError = SCNetworkError(errorDescription: AppError.Enums.NetworkError.dataNotFound.errorDescription,
                                                   errorCode: AppError.Enums.NetworkError.dataNotFound.errorCode)
            return .failure(dataNotFoundError)
        }
        
        // Check if Parsing is proper
        guard let data = try? Data(contentsOf: pathString) else {
            let parsingError = SCNetworkError(errorDescription: AppError.network(type: .parsing(dataString: "", description: "")).errorDescription,
                                              errorCode: nil)
            return .failure(parsingError)
        }
        return .success(data)
    }
}
struct SCNetworkError: Error, Codable {
    let errorDescription: String?
    let errorCode: Int?
}


struct SuccessResponse: Codable {
    let success: Bool
    let statusCode: Int
}
