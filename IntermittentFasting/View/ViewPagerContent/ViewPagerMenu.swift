//
//  ViewPagerMenu.swift
//  Test3
//
//  Created by sama73 on 2019. 4. 30..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

// 프로토콜 정의
@objc protocol ViewPagerMenuDelegate: NSObjectProtocol {
    @objc func scrollMenuViewSelected(_ index: Int)
}

class ViewPagerMenu: UIScrollView {

    private let scrollMenuViewMargin: CGFloat = 30
    private let indicatorHeight: CGFloat = 2
    private let indicatorPlusWidth: CGFloat = 21
    

    var delegateSub: ViewPagerMenuDelegate?

    // 인디게이터 뷰
    var vIndicator: UIView? = nil
    
    var vMenuContent: UIView? = nil

    // 메뉴 버튼
    var arrMenuButtons: [UIButton] = []
    
    // 메뉴 아이템 초기화
    func initMenuItems(_ viewPagerInfo: ViewPagerInfo) {
        
        self.vMenuContent = UIView(frame: self.bounds)
        self.addSubview(self.vMenuContent!)
        
        // 메뉴 버튼 타이틀
        var arrMenuInfos: [String] = []
        for vc in viewPagerInfo.arrChildController! {
            if let title: String = vc.title {
                arrMenuInfos += [title]
            }
            else {
                arrMenuInfos += ["미정"]
            }
        }

        var buttonWidth: CGFloat = 0;
        let itemfont = UIFont.systemFont(ofSize: viewPagerInfo.menuButtonfontSize)
        var frame: CGRect = self.bounds
        
        // 첫번째 문자 사이즈
        var firstTextSize: CGSize = CGSize.zero
        
        for i in 0..<arrMenuInfos.count {
            let title: String = arrMenuInfos[i]
            
            let textSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: itemfont])
            let strikeWidth: CGFloat = textSize.width
            buttonWidth = strikeWidth + self.indicatorPlusWidth + 8
            
            // 첫번째 문자 사이즈
            if i == 0 {
                firstTextSize = textSize
            }
            
            frame.size.width = buttonWidth
            let btnItem = UIButton(frame: frame)
            btnItem.titleLabel?.font = itemfont
            btnItem.setTitle(title, for: UIControl.State.normal)
            btnItem.setTitleColor(viewPagerInfo.menuButtonColorNormal, for: UIControl.State.normal)
            btnItem.setTitleColor(viewPagerInfo.menuButtonColorSelected, for: UIControl.State.selected)
            btnItem.tag = i
            btnItem.addTarget(self, action: #selector(self.onMenuItemClick(_:)), for: .touchUpInside)
            
            self.vMenuContent!.addSubview(btnItem)
            
            self.arrMenuButtons += [btnItem]
            
            frame.origin.x += buttonWidth
            print(buttonWidth)
        }
        
        // 인디게이터 뷰
        let indicatorX: CGFloat = self.indicatorPlusWidth / 2
        self.vIndicator = UIView(frame: CGRect(x: indicatorX, y: frame.height - indicatorHeight, width: firstTextSize.width + 8, height: indicatorHeight))
        self.vIndicator!.backgroundColor = viewPagerInfo.menuButtonColorSelected
        
        self.vMenuContent!.addSubview(self.vIndicator!)
    }
    
    // 화면 레이어 정보 갱신
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frame: CGRect = self.bounds
        
        var fullWidth: CGFloat = 0
        for btnItem in arrMenuButtons {
            fullWidth += btnItem.frame.width
        }
        
        self.contentSize = CGSize(width: fullWidth, height: frame.height)
        self.vMenuContent!.frame = CGRect(x: 0, y: 0, width: fullWidth, height: frame.height)
        
        // 메뉴폭이 지정 폭 보다 작으면 메뉴폭으로 지정
//        var frame2: CGRect = self.frame
//        if self.frame.width > fullWidth {
////            frame.origin.x = 0.0
//            frame2.size.width = fullWidth
//            self.frame = frame2
//        }
    }
    
    // 메뉴탭 선택
    func setCurrentIndex(_ currentIndex: Int) {
        for i in 0..<arrMenuButtons.count {
            let btnItem: UIButton = arrMenuButtons[i]
            btnItem.isSelected = i == currentIndex ? true : false
        }
    }
    
    // 인디게이터 위치 변경
    func indicatorViewFrameWithRatio(ratio: CGFloat, isNextItem: Bool, toIndex: Int) {
        if ratio > 1.0 {
            return
        }
        
        let fromIndex: Int = toIndex + 1
        let fromItem: UIButton = arrMenuButtons[fromIndex]
        let toItem: UIButton = arrMenuButtons[toIndex]
        
        let fromItemCenterX = fromItem.center.x
        let fromItemIndicatorWidth = fromItem.frame.width
        let toItemCenterX = toItem.center.x
        let toItemIndicatorWidth = toItem.frame.width
        var indicatorCenterX: CGFloat = 0.0
        var indiatorWidth: CGFloat = 0.0
        
        if isNextItem {
            indicatorCenterX = toItemCenterX + ((fromItemCenterX - toItemCenterX) * ratio);
            indiatorWidth = toItemIndicatorWidth + ((fromItemIndicatorWidth - toItemIndicatorWidth) * ratio);
        }
        else {
            indicatorCenterX = fromItemCenterX - ((fromItemCenterX - toItemCenterX) * ratio);
            indiatorWidth = fromItemIndicatorWidth - ((fromItemIndicatorWidth - toItemIndicatorWidth) * ratio);
        }
        
        // 인디게이트 위치 변경
        let indicatorX: CGFloat = indicatorCenterX - (indiatorWidth / 2.0)
        var frame = self.vIndicator!.frame
        
        frame.origin.x = indicatorX + self.indicatorPlusWidth / 2.0
        frame.size.width = indiatorWidth - self.indicatorPlusWidth
        
        self.vIndicator!.frame = frame
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // MARK: - UIButton Action
    @IBAction func onMenuItemClick(_ sender: UIButton) {
        
        if let delegate = self.delegateSub {
            if delegate.responds(to: #selector(delegate.scrollMenuViewSelected(_:))) {
                delegate.scrollMenuViewSelected(sender.tag)
            }
        }
    }
}
