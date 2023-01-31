//
//  DefaultCollectionViewDataSource.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import UIKit
public class DefaultCollectionViewDataSource: NSObject, UICollectionViewDataSource, CollectionViewProtocol , MapCellViewModel, GetListViewModelProtocol{
    
    
    let listViewModelDelegate: GetListViewModelProtocol
    let mapCellViewModelDelegate: MapCellViewModel
    let registerCellDelegate: RegisterCellProtocol?
    weak var collectionView: UICollectionView?
    func setSectionObserver() {
        self.listViewModel().sections.addObserver { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    public init(
        collectionView: UICollectionView?,
        tableViewModelDelegate: GetListViewModelProtocol,
        mapCellViewModelDelegate: MapCellViewModel,
        registerCellDelegate: RegisterCellProtocol?
    ) {
        self.collectionView = collectionView
        self.listViewModelDelegate = tableViewModelDelegate
        self.mapCellViewModelDelegate = mapCellViewModelDelegate
        self.registerCellDelegate = registerCellDelegate
        self.registerCellDelegate?.registerCell()
        super.init()
        self.collectionView?.dataSource = self
        setSectionObserver()
    }
    deinit{
        self.listViewModel().sections.removeObserver()
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.internal_numberOfSections(in: collectionView)
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.internal_collectionView(collectionView, numberOfRowsInSection: section)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.internal_collectionView(collectionView, cellForRowAt: indexPath)
    }

    
    public func listViewModel() -> ListViewModelProtocol {
        return self.listViewModelDelegate.listViewModel()
    }
    
    public func identifierFor(itemViewModel: ItemViewModelProtocol) -> String {
        self.mapCellViewModelDelegate.identifierFor(itemViewModel: itemViewModel)
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
        
}

