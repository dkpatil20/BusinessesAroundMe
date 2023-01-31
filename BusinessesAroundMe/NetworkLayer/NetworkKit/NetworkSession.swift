//
//  NetworkSession.swift
//

import Foundation


extension URLSession: NetworkSession {
    
    private typealias DataTaskCompletionCallback = (Data?, URLResponse?, Error?) -> Void
    
    private func handleCompletionBlock(
        _ request: Requestable,
        response: Result<Data, Error>,
        completionHandler: @escaping ((Result<Data, Error>) -> Void)
    ) {
        switch request {
        case let request as CallBackThread:
            request.callbackDispatchQueue.async {
                completionHandler(response)
            }
        default:
            completionHandler(response)
        }
    }
    
    public func call<E: ErrorType>(_ request: Requestable, errorType: E.Type, then completionHandler: @escaping ((Result<Data, Error>) -> Void)) -> URLSessionDataTask? {
        
        guard let urlRequest = request.urlRequest else {
            completionHandler(.failure(AppError.network(type: .dataNotFound)))
            Logger.log("====== Invalid url request: \(request) ======")
            return nil
        }
        let complation: DataTaskCompletionCallback = { [weak self] (data, response, error) in
            
            if let requestError = error as NSError? {
                self?.handleCompletionBlock(
                    request,
                    response: .failure(AppError.network(type: .error(error: requestError))),
                    completionHandler: completionHandler
                )
                return
            }
            let acceptedStatusCode = Set(200...399)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            guard acceptedStatusCode.contains(statusCode) else {
                let error: Error
                if statusCode == 401 {
                    error = AppError.network(type: .unauthorized)
                }else {
                    if let data = data {
                        do {
                            let errorResponse = try JSONDecoder().decode(errorType, from: data)
                            error = AppError.network(type: .error(error: errorResponse))
                        } catch let err as NSError {
                            error = AppError.network(type: .parsing(dataString: data.prettyPrintedJSON ?? "",
                                                                    description: err.description))
                        }
                    }
                    else {
                        error = AppError.network(type: .custom(
                            errorCode: statusCode,errorDescription: HTTPURLResponse.localizedString(forStatusCode: statusCode)))
                    }
                }

                self?.handleCompletionBlock(
                    request,
                    response: .failure(error),
                    completionHandler: completionHandler
                )
                return
            }
            
            guard let data = data else {
                self?.handleCompletionBlock(
                    request,
                    response: .failure(AppError.network(type: .dataNotFound)),
                    completionHandler: completionHandler
                )
                return
            }
            
            self?.handleCompletionBlock(
                request,
                response: .success(data),
                completionHandler: completionHandler
            )
        }
        let task = self.dataTask(with: urlRequest, completionHandler: complation)
        task.resume()
        return task
    }
}

