//
//  ViewPagerMenu.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 29..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

protocol ViewPagerMenuDelegate: NSObjectProtocol {
    func scrollMenuViewSelectedIndex(_ index: Int)
}

class ViewPagerMenu: UIScrollView {

    private let kYSLScrollMenuViewMargin: CGFloat = 30
    private let kYSLIndicatorHeight: CGFloat = 3
    private let kYSLIndicatorPlusWidth: CGFloat = 21
    
    var delegateSub: ViewPagerMenuDelegate?
    var vMenuContent: UIView?
    
    var arrItemView: [Any] = []
    var indicatorView: UIView?
    
    func initWithMenuItems(_ dicSettingInfo: [AnyHashable : Any]?) {
        backgroundColor = UIColor.clear
        
        // base 설정
        var itemfont = UIFont.systemFont(ofSize: 14)
        var itemTitleColor: UIColor? = UIColor.init(hex: 0xffffff, alpha: 0.5)
        var itemTitleSelectedColor: UIColor? = UIColor.init(hex: 0xef0010)
        var itemIndicatorColor: UIColor? = UIColor.init(hex: 0xef0010)
        
        var colorTemp = dicSettingInfo!["menuTitleColor"] as? UIColor
        if colorTemp != nil {
            itemTitleColor = colorTemp
        }
        
        colorTemp = dicSettingInfo!["menuTitleSelectedColor"] as? UIColor
        if colorTemp != nil {
            itemTitleSelectedColor = colorTemp
        }
        
        var fontTemp = dicSettingInfo!["menuTitleFont"] as? UIFont
        if fontTemp != nil {
            itemfont = fontTemp!
        }
        
        colorTemp = dicSettingInfo!["menuIndicatorColor"] as? UIColor
        if colorTemp != nil {
            itemIndicatorColor = colorTemp
        }
        
//        var strTemp = dicSettingInfo["menuButtonType"] as? String
//        if strTemp != nil {
//            menuButtonType = Int(truncating: strTemp ?? "") ?? 0
//        }
        
    }
    
    func setShadowView() {
    }
    
    func setIndicatorViewFrameWithRatio(_ ratio: CGFloat, isNextItem: Bool, to toIndex: Int) {
    }
    
    func setCurrentIndex(_ currentIndex: Int) {
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
