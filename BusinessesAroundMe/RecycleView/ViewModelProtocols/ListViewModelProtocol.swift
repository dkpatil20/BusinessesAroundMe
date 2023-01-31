//
//  ListViewModelProtocol.swift
//  RecycleViewProtocol
//
//  Created by Dhiraj Kumar Patil on 18/12/20.
//

import Foundation
public protocol ListViewModelProtocol {
    
    typealias Items = [SectionViewModelProtocol]
    typealias ItemsIndex = Items.Index
    typealias ItemsElement = Items.Element

    var sections: Observable<Items> { get set }
    
    func numberOfSection() -> Int
    func numberOfRowIn(section: Int) -> Int
    func sectionAt(index: Int) -> SectionViewModelProtocol?
    func itemAt(indexPath: IndexPath) -> ItemViewModelProtocol?
}
public extension ListViewModelProtocol {
    func numberOfSection() -> Int{
        return self.count
    }
    func numberOfRowIn(section: Int) -> Int {
        return self[section]?.numberOfRowIn() ?? 0
    }
    func sectionAt(index: Int) -> SectionViewModelProtocol? {
        return self[index]
    }
    
    func itemAt(indexPath: IndexPath) -> ItemViewModelProtocol? {
        return self[indexPath.section]?.itemFor(row: indexPath.row)
    }
}
public extension ListViewModelProtocol {
    var count: Int {
        sections.value.count
    }
    subscript(position: ItemsIndex) -> ItemsElement? {
        get {
            guard numberOfSection() > position else {
                return nil
            }

            return sections.value[position]
        }
    }
}

enum APIStatus {
    case notStarted
    case inProgress
    case finished
}
protocol Pagination: AnyObject {
    var total: Int { get set }
    var offset: Int { get set }
    var limit: Int { get }
    var isAPICalled: APIStatus { get set}
    var callBefore: IndexPath { get }
    func callNextPage()
}

extension Pagination {
    func shouldCallAPI() -> Bool {

        if isAPICalled == .inProgress || total > 0 , total <= self.offset + self.limit {
            return false
        }
        self.isAPICalled = .inProgress
        self.offset += self.limit
        return true
    }
    
    func apiCallFinished(total: Int?) {
        if let total = total {
            self.total = total            
        }
        self.isAPICalled = .finished
    }
}


extension ListViewModelProtocol where Self: Pagination {
    func itemAt(indexPath: IndexPath) -> ItemViewModelProtocol? {
        let section = sectionAt(index: indexPath.section)
        if numberOfSection() == indexPath.section + callBefore.section + 1, section?.numberOfRowIn() == indexPath.row + callBefore.row {
            Logger.log(#function,indexPath)
            self.callNextPage()
        }
        return section?.itemFor(row: indexPath.row)
    }

}
