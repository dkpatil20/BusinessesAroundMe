//
//  HTTPMethod+String.swift
//  

import Foundation


public extension HTTPRequestType {
  
  var httpMethod: String {
    switch self {
        /// The `GET` method requests a representation of the specified resource.
        ///
        /// Requests using `GET` should only retrieve data.
    case .get: return "GET"
      
        /// The `POST` method is used to submit an entity to the specified resource, often causing a change in state or side effects on the server.
    case .post : return  "POST"
      
        /// The `PUT` method replaces all current representations of the target resource with the request payload.
    case .put : return  "PUT"
      
        /// The `DELETE` method deletes the specified resource.
    case .delete : return  "DELETE"
      
        /// The `PATCH` method is used to apply partial modifications to a resource.
    case .patch : return  "PATCH"
    }
  }
}
