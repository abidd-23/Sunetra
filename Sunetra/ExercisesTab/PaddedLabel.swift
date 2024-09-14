//  PaddedLabel.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 08/06/24.
//

import Foundation
import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) // Adjust the insets as needed

    // Override the drawText method to apply text insets
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    // Override intrinsicContentSize to include text insets in the label size
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
    
    // Override layoutSubviews to apply corner radius and masks
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
}
