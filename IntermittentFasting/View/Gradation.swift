import UIKit

@IBDesignable
class GradationView: UIView {
    
    // MARK:- Variables
    @IBInspectable var startColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.white {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.black {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var gradient: CAGradientLayer?
    
    
    
    // MARK:- Methods
    private func initGradation() {
        // 그라데이션이 이미 있다면 삭제한다.
        if let gradient = self.gradient {
            gradient.removeFromSuperlayer()
        }
        
        let gradient = createGradient()
        self.layer.insertSublayer(gradient, at: 0)
        self.gradient = gradient
    }



    private func updateGradient() {
        if let gradient = self.gradient {
            let startColor = self.startColor
            let endColor = self.endColor
            
            gradient.colors = [startColor.cgColor, endColor.cgColor]
            gradient.startPoint = CGPoint(x: startPoint.x, y: startPoint.y)
            gradient.endPoint = CGPoint(x: endPoint.x, y: endPoint.y)
            
            gradient.cornerRadius = radius
            gradient.borderWidth = borderWidth
            gradient.borderColor = borderColor.cgColor
        }
    }
    
    
    
    // 모든 뷰의 크기에 맞게 조절하기 위해 layoutSubviews의 메소드를 이용
    // 이를 사용하지 않으면 하나의 고정된 뷰의 크기대로 나온다.
    override func layoutSubviews() {
        initGradation()
        updateGradient()
    }

    
    
    private func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        return gradient
    }
    
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initGradation()
        updateGradient()
    }
}
