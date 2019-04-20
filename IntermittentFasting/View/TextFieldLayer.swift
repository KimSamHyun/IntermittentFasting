//
//  TextFieldLayer.swift
//  IntermittentFasting
//
//  Created by Byunsangjin on 18/04/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit

@IBDesignable
class TextFieldLayer: UITextField {
    // MARK:- Variables
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            setLayer()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            setLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayer()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setLayer()
    }
    
    
    
    // MARK:- Methods
    private func setLayer() {
        let border = CALayer()
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = borderWidth
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
