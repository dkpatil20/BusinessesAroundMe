//
//  OpenHoursFirstTableViewCell.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 31/01/23.
//

import UIKit

class HeadingSubheadingWithAccessory: TableViewCell {
    
    private let baseView: UIView = UIView()
    private let headingLabel: PaddingLabel = PaddingLabel()
    private let subHeading: PaddingLabel = PaddingLabel()
    private let arrowImageView: UIImageView = UIImageView()
    private var widthConstraint: NSLayoutConstraint?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func setupBaseView() {
        self.contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: contentView.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            baseView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -10),
            baseView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        baseView.backgroundColor = .color(from: .background)
    }
    fileprivate func setupHeadingLabel() {
        headingLabel.configurePaddedLabel(backgroundColor: .background)
        self.baseView.addSubview(headingLabel)
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: baseView.topAnchor),
            headingLabel.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            headingLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
        ])
    }
    fileprivate func setupSubHeadingLabel() {
        subHeading.configurePaddedLabel(backgroundColor: .background)
        subHeading.numberOfLines = 2
        subHeading.textAlignment = .right
        subHeading.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        subHeading.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750),for: .horizontal)
        self.baseView.addSubview(subHeading)
        NSLayoutConstraint.activate([
            subHeading.topAnchor.constraint(equalTo: baseView.topAnchor),
            subHeading.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            subHeading.leadingAnchor.constraint(equalTo: headingLabel.trailingAnchor),
            subHeading.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor),
        ])
    }
    fileprivate func setupArrowImageView() {
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .color(from: AppColors.secondaryLabel)
        self.baseView.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowImageView.topAnchor.constraint(equalTo: baseView.topAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
        ])
        widthConstraint = arrowImageView.widthAnchor.constraint(equalToConstant: 24)
        widthConstraint?.isActive = true
        
    }
    func setupView() {
        self.contentView.backgroundColor = .color(from: .background)
        setupBaseView()
        setupHeadingLabel()
        setupArrowImageView()
        setupSubHeadingLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HeadingSubheadingWithAccessory: ItemViewProtocol {
    fileprivate func updateCell(_ viewModel: OpenHoursFirstCellViewModel) {
        self.headingLabel.text = viewModel.headingText.text
        self.headingLabel.textColor = UIColor.color(from: viewModel.headingText.color)
        self.subHeading.text = viewModel.subHeadingText
        self.arrowImageView.image = UIImage(systemName: viewModel.arrowIcon.rawValue)
        self.arrowImageView.isHidden = false
        widthConstraint?.constant = 24
    }
    
    fileprivate func updateCell(_ viewModel: HeadingSubHeadingCellViewModel) {
        self.headingLabel.text = viewModel.heading
        self.headingLabel.textColor = UIColor.color(from: .secondaryLabel)
        self.subHeading.text = viewModel.subHeading
        self.arrowImageView.image = nil
        self.arrowImageView.isHidden = true
        widthConstraint?.constant = 0
    }
    
    func updateView(itemViewModel: ItemViewModelProtocol) {

        switch itemViewModel {
        case let viewModel as OpenHoursFirstCellViewModel:
            updateCell(viewModel)
        case let viewModel as HeadingSubHeadingCellViewModel:
            updateCell(viewModel)

        default:
            break
        }
    }
    
    
}
