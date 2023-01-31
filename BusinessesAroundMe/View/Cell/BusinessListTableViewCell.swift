//
//  BusinessListTableViewCell.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 26/01/23.
//

import UIKit

class BusinessListTableViewCell: TableViewCell {

    private let baseView: UIView = UIView()
    private let businessImageView: AsynImageView = AsynImageView()
    private let nameLabel: UILabel = UILabel()
    private let pricingLabel: PaddingLabel = PaddingLabel()
    private let ratingLabel: PaddingLabel = PaddingLabel()
    
    fileprivate func setupImageView() {
        businessImageView.contentMode = .scaleAspectFill
        businessImageView.clipsToBounds = true
        businessImageView.backgroundColor = .lightGray
        businessImageView.translatesAutoresizingMaskIntoConstraints = false
        self.baseView.addSubview(businessImageView)
        NSLayoutConstraint.activate([
            businessImageView.topAnchor.constraint(equalTo: baseView.topAnchor),
            businessImageView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            businessImageView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
        ])
        let height = businessImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2)
        height.priority = UILayoutPriority(999)
        height.isActive = true


    }
    
    fileprivate func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .color(from: .label)
        nameLabel.numberOfLines = 2
        nameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751),for: .vertical)
        
        self.baseView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: businessImageView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: businessImageView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -10)
        ])
    }

    
    fileprivate func setupPricingLabel() {
        pricingLabel.configurePaddedLabel()
        self.baseView.addSubview(pricingLabel)
        NSLayoutConstraint.activate([
            pricingLabel.leadingAnchor.constraint(equalTo: businessImageView.leadingAnchor, constant: 10),
            pricingLabel.bottomAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: -10)
        ])
    }
    fileprivate func setupRatingLabel() {
        ratingLabel.configurePaddedLabel()
        self.baseView.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            ratingLabel.trailingAnchor.constraint(equalTo: businessImageView.trailingAnchor, constant: -10),
            ratingLabel.bottomAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: -10)
        ])
    }
    
    fileprivate func setupBaseView() {
        self.contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        
        baseView.layer.borderColor = UIColor.color(from: .secondaryBackground)?.cgColor
        baseView.layer.borderWidth = 1
        baseView.clipsToBounds = true
        baseView.layer.cornerRadius = 10
        baseView.backgroundColor = .color(from: .secondaryBackground)

    }
    
    func setupView() {

        self.contentView.backgroundColor = .color(from: .background)
        setupBaseView()
        setupImageView()
        setupNameLabel()
        setupPricingLabel()
        setupRatingLabel()
    }
}

extension BusinessListTableViewCell: ItemViewProtocol {
    func updateView(itemViewModel: ItemViewModelProtocol) {
        guard let vm = itemViewModel as? BusinessListViewModel else {
            return
        }
        self.businessImageView.setImage(vm.imageURL)
        nameLabel.text = vm.name
        ratingLabel.text = vm.rating
        pricingLabel.text = vm.price
    }
}
