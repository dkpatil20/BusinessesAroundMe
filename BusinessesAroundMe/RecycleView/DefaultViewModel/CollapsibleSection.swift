//
//  CollapsibleSection.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import Foundation


protocol CollapsibleItem {
    func setCollapsibleState(isCollapsed: Bool)
}
protocol CollapsibleItemSection {
    func setCollapsibleState()
}

class CollapsibleSection: SectionViewModelProtocol, CollapsibleItemSection {
    
    var items: [ItemViewModelProtocol]
    
    private let mainItem: ItemViewModelProtocol & CollapsibleItem
    private let collapsibleItem: [ItemViewModelProtocol]
    private var isCollapsed: Bool
    
    init(mainItem: ItemViewModelProtocol & CollapsibleItem, collapsibleItem: [ItemViewModelProtocol], isCollapsed: Bool) {
        self.mainItem = mainItem
        self.collapsibleItem = collapsibleItem
        self.isCollapsed = isCollapsed
        var array: [ItemViewModelProtocol] = [mainItem]
        if !isCollapsed {
            array.append(contentsOf: collapsibleItem)
        }
        self.items = array
    }
    func setCollapsibleState() {
        isCollapsed.toggle()
        mainItem.setCollapsibleState(isCollapsed: isCollapsed)
        var array: [ItemViewModelProtocol] = [mainItem]
        if !isCollapsed {
            array.append(contentsOf: collapsibleItem)
        }
        self.items = array

    }
    
}
