//
//  CustomTextField.swift
//  Sakadatsu
//
//  Created by Masato Sawada on 2022/11/13.
//

import UIKit

class CustomLabel: UILabel {
    
    @IBInspectable var topPadding: CGFloat = 20
    @IBInspectable var bottomPadding: CGFloat = 20
    @IBInspectable var leftPadding: CGFloat = 20
    @IBInspectable var rightPadding: CGFloat = 20
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += (topPadding + bottomPadding)
        size.width += (leftPadding + rightPadding)
        return size
    }
    
    
}
