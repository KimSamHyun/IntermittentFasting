//
//  UIButton+Radius.swift
//  IntermittentFasting
//
//  Created by Byunsangjin on 17/04/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonLayer: UIButton {
    // MARK:- Variables
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            updateGradient()
            updateBorder()
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            updateGradient()
            updateBorder()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateGradient()
            updateBorder()
        }
    }
    
    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet {
            updateGradient()
            updateBorder()
        }
    }
    
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            updateGradient()
            updateBorder()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.clear {
        didSet {
            updateGradient()
            updateBorder()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            updateGradient()
            updateBorder()
        }
    }
    
    private var gradient: CAGradientLayer?
    
    
    
    // MARK:- Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initGradation()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initGradation()
    }
    
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initGradation()
        updateBorder()
        updateGradient()
    }
    
    
    
    private func initGradation() {
        self.backgroundColor = UIColor.clear
        
        // 그라데이션이 이미 있다면 삭제한다.
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        
        let gradient = createGradient()
        self.layer.insertSublayer(gradient, at: 0)
        self.gradient = gradient
    }
    
    
    
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    
    
    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor
            let endColor = self.endColor
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            gradient.startPoint = CGPoint(x: startPoint.x, y: startPoint.y)
            gradient.endPoint = CGPoint(x: endPoint.x, y: endPoint.y)
        }
    }
    
    
    
    private func updateBorder() {
        if let gradient = self.gradient {
            gradient.borderColor = borderColor?.cgColor
            gradient.borderWidth = borderWidth
            gradient.cornerRadius = cornerRadius
        }
    }
}
