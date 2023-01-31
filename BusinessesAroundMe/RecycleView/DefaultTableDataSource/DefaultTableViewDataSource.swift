//
//  DefaultTableViewDataSource.swift
//  RecycleViewProtocol
//
//  Created by Dhiraj Kumar Patil on 25/06/21.
//

import UIKit

///
public class DefaultTableViewDataSource: NSObject, UITableViewDataSource, TableViewProtocol , MapCellViewModel, GetListViewModelProtocol{
    
    let tableViewModelDelegate: GetListViewModelProtocol
    let mapCellViewModelDelegate: MapCellViewModel
    let registerCellDelegate: RegisterCellProtocol?
    weak var tableView: UITableView?
    public init(
        tableView: UITableView?,
        tableViewModelDelegate: GetListViewModelProtocol,
        mapCellViewModelDelegate: MapCellViewModel,
        registerCellDelegate: RegisterCellProtocol?
    ) {
        self.tableView = tableView
        self.tableViewModelDelegate = tableViewModelDelegate
        self.mapCellViewModelDelegate = mapCellViewModelDelegate
        self.registerCellDelegate = registerCellDelegate
        self.registerCellDelegate?.registerCell()
        super.init()
        self.tableView?.dataSource = self
        self.listViewModel().sections.addObserver { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView?.reloadData()                
            }
        }
    }
    
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        let numberOfSections = self.internal_numberOfSections(in: tableView)
        return numberOfSections
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = self.internal_tableView(tableView, numberOfRowsInSection: section)
        return numberOfRowsInSection
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.internal_tableView(tableView, cellForRowAt: indexPath)
        return cell
    }
    
    public func listViewModel() -> ListViewModelProtocol {
        return self.tableViewModelDelegate.listViewModel()
    }
    
    public func identifierFor(itemViewModel: ItemViewModelProtocol) -> String {
        self.mapCellViewModelDelegate.identifierFor(itemViewModel: itemViewModel)
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
        
}
