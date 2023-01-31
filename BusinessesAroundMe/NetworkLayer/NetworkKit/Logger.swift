//
//  Logger.swift
//  

import Foundation

final class Logger: NSObject {
        
    static func log(_ items: Any...){
        #if DEBUG
        print(items)
        #endif
    }
}
