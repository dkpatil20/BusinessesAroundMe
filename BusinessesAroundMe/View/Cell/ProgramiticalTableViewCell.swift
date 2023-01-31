//
//  ProgramiticalTableViewCell.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 30/01/23.
//

import UIKit

protocol ProgramiticalCellType {
    func setupView()
}

typealias TableViewCell = ProgramiticalTableViewCell & ReuseIdentifierProtocol & ProgramiticalCellType

class ProgramiticalTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let programiticalSelf = self as? ProgramiticalCellType {
            programiticalSelf.setupView()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
