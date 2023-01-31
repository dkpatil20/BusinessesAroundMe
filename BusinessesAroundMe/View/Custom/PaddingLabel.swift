//
//  PaddingLabel.swift
//  BusinessesAroundMe
//
//  Created by Dhiraj Patil on 27/01/23.
//

import UIKit
class PaddingLabel: UILabel {

    var inset: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + inset.left + inset.right,
                      height: size.height + inset.top + inset.bottom)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (inset.left + inset.right)
        }
    }
}
extension PaddingLabel {
    func configurePaddedLabel(backgroundColor: AppColors = .secondaryBackground, textColor: AppColors = .secondaryLabel) {
        let label = self
        label.inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.backgroundColor = .color(from: backgroundColor)
        label.textColor = .color(from: textColor)
    }
}
