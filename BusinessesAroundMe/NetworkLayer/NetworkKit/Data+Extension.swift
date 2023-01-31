//
//  File.swift
//  

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    var prettyPrintedJSON: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let jsonData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let formattedJSON = String(data: jsonData, encoding: .utf8) else { return nil }
        return formattedJSON.replacingOccurrences(of: "\\/", with: "/")
    }
}
