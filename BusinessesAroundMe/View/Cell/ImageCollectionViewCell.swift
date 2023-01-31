//
//  ImageCollectionViewCell.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import UIKit

typealias CollectionViewCell = UICollectionViewCell & ReuseIdentifierProtocol

class ImageCollectionViewCell: CollectionViewCell {
    
    private let imageView: AsynImageView = {
       let iv = AsynImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCollectionViewCell: ItemViewProtocol {
    func updateView(itemViewModel: ItemViewModelProtocol){
        if let viewModel = itemViewModel as? ImageCellViewModelType {
            self.imageView.setImage(viewModel.imageURL)
        }
    }

}
