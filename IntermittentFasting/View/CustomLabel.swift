//
//  CustomLabel.swift
//  IntermittentFasting
//
//  Created by Byunsangjin on 19/04/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {
    // MARK:- Variables
    @IBInspectable var characterSpace: CGFloat = 0.5 {
        didSet {
            setLabel()
        }
    }
    
    
    
    // MARK:- Methods
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setLabel()
    }
    
    
    
    private func setLabel() {
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpace, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
