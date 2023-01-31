//
//  Encodable+.swift
//

import Foundation
public extension Encodable {
     func asDictionary() throws -> [String: Any] {
         let data = try JSONEncoder().encode(self)
         guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
             throw NSError()
         }
         return dictionary
     }

     func toDictionary() -> [String:Any]? {
         return try? asDictionary()
     }

 }
