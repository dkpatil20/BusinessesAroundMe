//
//  APIService.swift
//

import Foundation


public class APIService: APIServicable {
    
    public init(networkSession: NetworkSession = URLSession.shared) {
        self.networkSession = networkSession
    }
    
    private let networkSession: NetworkSession
    

    @discardableResult
    public func getData<E: ErrorType>(_ request: Requestable, errorType: E.Type, then completionHandler: @escaping ((Result<Data, Error>) -> Void)) -> URLSessionDataTask? {
        return self.networkSession.call(request, errorType: errorType) { result in
            completionHandler(result)
        }
    }
    
    @discardableResult
    public func getString<E: ErrorType>(_ request: Requestable, errorType: E.Type, then completionHandler: @escaping ((Result<String, Error>) -> Void)) -> URLSessionDataTask? {
        
        return self.networkSession.call(request, errorType:errorType) { result in
            switch result {
            case .success( let data):
                guard let dataString = String(data: data, encoding: .utf8) else {
                    completionHandler(.failure(AppError.network(type: .dataNotFound)))
                    return
                }
                completionHandler(.success(dataString))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    @discardableResult
    public func getDecodableData<T: Decodable, E:ErrorType>(of type: T.Type, errorType: E.Type, request: Requestable, then completionHandler: @escaping ((Result<T, Error>) -> Void)) -> URLSessionDataTask? {
        return self.networkSession.call(request, errorType: errorType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success( let data):
                let result = self.parse(toType: T.self, data: data)
                completionHandler(result)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    public func cancel(task: URLSessionDataTask?) {
        task?.cancel()
    }
    
    private func parse<T: Decodable>(toType: T.Type, data: Data) -> Result<T, Error> {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        }
        catch let error as NSError {
            let str = data.prettyPrintedJSON ?? ""
            return .failure(AppError.network(type: .parsing(dataString: str, description: error.errorDescription)))
        }
    }
}
