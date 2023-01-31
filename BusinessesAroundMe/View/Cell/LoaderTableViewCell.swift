//
//  LoaderTableViewCell.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 30/01/23.
//

import UIKit

class LoaderTableViewCell: TableViewCell {
    private let loadingIndicator = UIActivityIndicatorView()
    
    func addLoadingIndicator() {
        loadingIndicator.color = .color(from: .secondaryLabel)

        contentView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func setupView() {
        addLoadingIndicator()
        self.contentView.backgroundColor = .color(from: .background)
        self.contentView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

extension LoaderTableViewCell: ItemViewProtocol {
    func updateView(itemViewModel: ItemViewModelProtocol) {
        if let vm = itemViewModel as? LoaderTableViewCellViewModel {
            if vm.isLoading {
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.stopAnimating()
            }
        }
    }
}
