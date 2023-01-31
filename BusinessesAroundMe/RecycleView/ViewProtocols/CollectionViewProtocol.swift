//
//  CollectionViewProtocol.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import UIKit
public protocol CollectionViewProtocol {
    func internal_numberOfSections(in collectionView: UICollectionView) -> Int
    func internal_collectionView(_ collectionView: UICollectionView, numberOfRowsInSection section: Int) -> Int
    func internal_collectionView(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell
}

public extension CollectionViewProtocol where Self: GetListViewModelProtocol & MapCellViewModel {

    func internal_numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.listViewModel().numberOfSection()
    }

    func internal_collectionView(_ collectionView: UICollectionView, numberOfRowsInSection section: Int) -> Int {
        return self.listViewModel().numberOfRowIn(section: section)
    }

    func internal_collectionView(_ collectionView: UICollectionView, cellForRowAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let itemViewModel = self.listViewModel().itemAt(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let identifier = self.identifierFor(itemViewModel: itemViewModel)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let itemView = cell as? ItemViewProtocol {
            itemView.updateView(itemViewModel: itemViewModel)
        }
        return cell
    }
}
