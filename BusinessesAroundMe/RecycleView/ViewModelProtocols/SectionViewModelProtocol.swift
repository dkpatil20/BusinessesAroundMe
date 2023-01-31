//
//  SectionViewModelProtocol.swift
//  RecycleViewProtocol
//
//  Created by Dhiraj Kumar Patil on 18/12/20.
//

import Foundation
public protocol SectionViewModelProtocol: AnyObject {
    var items:[ItemViewModelProtocol] { get set }
   
    func numberOfRowIn() -> Int
    func itemFor(row: Int) -> ItemViewModelProtocol?
}

public extension SectionViewModelProtocol {
    func numberOfRowIn() -> Int {
        return items.count
    }
    func itemFor(row: Int) -> ItemViewModelProtocol? {
        guard items.count > row else {
            return nil
        }
        return items[row]
    }
}
