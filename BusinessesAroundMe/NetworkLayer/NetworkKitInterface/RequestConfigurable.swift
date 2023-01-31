//
//  RequestConfigurable.swift
//  
//

import Foundation

public protocol RequestConfigurableType {
  
    /// The cache policy of the request
  var cachePolicy: URLRequest.CachePolicy { get set }
  
    /// The timeout interval of the request
  var timeoutInterval: TimeInterval { get set }
    /// The request body type of the request. Can be either .xWWWFormURLEncoded or .JSON.
//  var requestBodyType: RequestBodyType? { get set }
  
    /// Enables or disables logging. `SHOULD ALWAYS BE FALSE IN RELEASE MODE`
  var verbose: Bool { get set }
}

public struct RequestConfigurable: RequestConfigurableType {
  
    /// The cache policy of the request. Default is `useProtocolCachePolicy`
  public var cachePolicy: URLRequest.CachePolicy
  
    /// The timeout interval of the request. Default is 60.0
  public var timeoutInterval: TimeInterval
  
    /// Enables or disables logging. `SHOULD ALWAYS BE FALSE IN RELEASE MODE`
  public var verbose: Bool
  
  public init(cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
              timeoutInterval: TimeInterval = 60.0,
              verbose: Bool = false) {
    self.cachePolicy = cachePolicy
    self.timeoutInterval = timeoutInterval
    self.verbose = verbose
  }
}
