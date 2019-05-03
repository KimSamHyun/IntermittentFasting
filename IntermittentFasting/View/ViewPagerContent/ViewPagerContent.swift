//
//  ViewPagerContent.swift
//  Test3
//
//  Created by sama73 on 2019. 5. 2..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

struct ViewPagerInfo {
    // 메뉴 버튼 Normal 색상
    var menuButtonColorNormal: UIColor = UIColor.lightGray
    // 메뉴 버튼 Selected 색상
    var menuButtonColorSelected: UIColor = UIColor.red
    // 메뉴 버튼 사이즈
    var menuButtonfontSize: CGFloat = 19.0
    // 메뉴 버튼 높이
    var menuButtonHeight: CGFloat = 45.0
    // 메뉴 버튼 시작 위치
    var menuButtonOffsetX: CGFloat = 0.0
    
    // 차일드 VC목록
    var arrChildController: [UIViewController]?
    
    init(menuButtonColorNormal: UIColor = UIColor.lightGray,
         menuButtonColorSelected: UIColor = UIColor.red,
         menuButtonfontSize: CGFloat = 19.0,
         menuButtonHeight: CGFloat = 45.0,
         menuButtonOffsetX: CGFloat = 0.0,
         arrChildController: [UIViewController]? = nil) {
        
        self.menuButtonColorNormal = menuButtonColorNormal
        self.menuButtonColorSelected = menuButtonColorSelected
        self.menuButtonfontSize = menuButtonfontSize
        self.menuButtonHeight = menuButtonHeight
        self.menuButtonOffsetX = menuButtonOffsetX
        self.arrChildController = arrChildController
    }
}

// 프로토콜 정의
@objc protocol ViewPagerContentDelegate: NSObjectProtocol {
    @objc func containerViewItem(_ index: Int)
}

class ViewPagerContent: UIView {
    
    // 이전 페이지
    var oldPageIndex: Int = -1
    // 현재 페이지
    var curPageIndex: Int = -1
    
    var oldContentOffset: CGPoint = CGPoint.zero
    
    var arrChildController: [UIViewController]!
    
    var viewPagerInfo: ViewPagerInfo?
    
    // 메뉴 탭바
    var menuTabbar: ViewPagerMenu?

    // 메뉴 컨텐츠
    var svContent: UIScrollView!
    
    var delegate: ViewPagerContentDelegate?

    // 뷰페이저 초기화
    func initContent(_ viewPagerInfo: ViewPagerInfo) {
        
        self.viewPagerInfo = viewPagerInfo
        self.arrChildController = viewPagerInfo.arrChildController
                
        var frameContent: CGRect = self.bounds
        // 메뉴 탭
        var frameMenu: CGRect = frameContent
        frameMenu.origin.x = viewPagerInfo.menuButtonOffsetX
        frameMenu.size.width -= viewPagerInfo.menuButtonOffsetX
        frameMenu.size.height = viewPagerInfo.menuButtonHeight
        self.menuTabbar = ViewPagerMenu(frame: frameMenu)
        self.menuTabbar!.initMenuItems(viewPagerInfo)
        self.menuTabbar!.delegateSub = self
        // 스크롤 바 표시
        self.menuTabbar!.showsHorizontalScrollIndicator = false
        self.menuTabbar!.showsVerticalScrollIndicator = false

        self.addSubview(self.menuTabbar!)

        
        // 메뉴 컨텐츠
        frameContent.origin.y = frameMenu.size.height
        frameContent.size.height -= frameMenu.size.height
        
        print(frameContent)
        
        // 뷰페이저 VC를 닮을 스크롤뷰 추가
        self.svContent = UIScrollView(frame: frameContent)
        // 페이징 설정
        self.svContent.isPagingEnabled = true
        // 스크롤 바 표시
        self.svContent.showsHorizontalScrollIndicator = false
        self.svContent.showsVerticalScrollIndicator = false
        // 수직/수평 한 방향으로만 스크롤 되도록 설정
        self.svContent.isDirectionalLockEnabled = true
        self.svContent.scrollsToTop = false
        self.svContent.bounces = false
        self.svContent.delegate = self
        
        self.svContent.contentSize = CGSize(width: frame.width * CGFloat(arrChildController.count), height: frame.height)
        
        self.addSubview(svContent)
        
        frame = self.svContent.bounds
        print(frame)
        
        for i in 0..<arrChildController.count {
            let vc: UIViewController = arrChildController[i]
            var frameTemp = frame
            frameTemp.origin.x = frameTemp.width * CGFloat(i)
            vc.view.frame = frameTemp
            self.svContent.addSubview(vc.view)
        }
        
        // 첫번째 메뉴 선택
        self.scrollMenuViewSelected(0)
    }
    
    // 화면 레이어 정보 갱신
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 메뉴 탭
        var frameMenu: CGRect = self.bounds
        frameMenu.origin.x = self.viewPagerInfo!.menuButtonOffsetX
        frameMenu.size.width -= self.viewPagerInfo!.menuButtonOffsetX
        frameMenu.size.height = self.viewPagerInfo!.menuButtonHeight
        self.menuTabbar!.frame = frameMenu
        
        // 메뉴 컨텐츠
        var frame: CGRect = self.bounds
        frame.origin.y = self.viewPagerInfo!.menuButtonHeight
        frame.size.height -= frame.origin.y
        self.svContent.frame = frame
        
        frame = self.svContent.bounds
        
        for i in 0..<arrChildController.count {
            let vc: UIViewController = arrChildController[i]
            var frameTemp = frame
            frameTemp.origin.x = frameTemp.width * CGFloat(i)
            vc.view.frame = frameTemp
        }
        
        self.svContent.contentSize = CGSize(width: frame.width * CGFloat(arrChildController.count), height: frame.height)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension ViewPagerContent: UIScrollViewDelegate {
    
    func displayScrollUI(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < scrollView.contentOffset.y {
            return
        }
        
        let oldPosX: CGFloat = CGFloat(self.curPageIndex) * scrollView.frame.width
        let ratio: CGFloat =  (scrollView.contentOffset.x - oldPosX) / scrollView.frame.width
        let isToNextItem: Bool = (scrollView.contentOffset.x > oldPosX)
        let toIndex: Int = isToNextItem ? self.curPageIndex + 1 : self.curPageIndex - 1
        // 일단 임시 처리
        let length: CGFloat = self.menuTabbar!.contentSize.width - self.menuTabbar!.frame.width
        let nextItemOffsetX: CGFloat = length * CGFloat(toIndex) / CGFloat((self.arrChildController.count - 1))
        let currentItemOffsetX: CGFloat = length * CGFloat(self.curPageIndex) / CGFloat((self.arrChildController.count - 1))

        var offset: CGPoint = self.menuTabbar!.contentOffset
        if toIndex >= 0 && toIndex < self.arrChildController.count {
            // MenuView Move
            if isToNextItem == true {
                offset.x = (nextItemOffsetX - currentItemOffsetX) * ratio + currentItemOffsetX
                self.menuTabbar!.setContentOffset(offset, animated: false)
                self.menuTabbar!.indicatorViewFrameWithRatio(ratio: ratio * 1, isNextItem: isToNextItem, toIndex: self.curPageIndex)
            }
            else {
                offset.x = currentItemOffsetX - (nextItemOffsetX - currentItemOffsetX) * ratio
                self.menuTabbar!.setContentOffset(offset, animated: false)
                self.menuTabbar!.indicatorViewFrameWithRatio(ratio: ratio * -1, isNextItem: isToNextItem, toIndex: toIndex)
            }
        }
        else if toIndex < 0 {
            self.menuTabbar!.setContentOffset(CGPoint.zero, animated: false)
            self.menuTabbar!.indicatorViewFrameWithRatio(ratio: 0.0, isNextItem: true, toIndex: 0)
        }
    }
    
    // 스크롤 뷰에서 내용 스크롤을 시작할 시점을 대리인에게 알립니다.
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging:")
        
        self.oldContentOffset = scrollView.contentOffset
    }
    
    // 2. 스크롤뷰가 스크롤 된 후에 실행된다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x != self.oldContentOffset.x {
            scrollView.isPagingEnabled = true
//            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: <#T##Double#>)
            
            displayScrollUI(scrollView)
        }
        else {
            scrollView.isPagingEnabled = false
        }
    }
    
    // 드래그가 스크롤 뷰에서 끝났을 때 대리자에게 알립니다.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging:willDecelerate:")
        
    }
    
    // (현재 못씀)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
        
    }
    
    // 스크롤뷰가 Touch-up 이벤트를 받아 스크롤 속도가 줄어들때 실행된다.
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
        
    }
    
    // 스크롤 애니메이션의 감속 효과가 종료된 후에 실행된다.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.oldContentOffset = scrollView.contentOffset
        
        let newPageIndex: Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        // 현재 선택된 페이지 인덱스와 같은 경우 더이상 처리하지 않는다.
        if self.curPageIndex == newPageIndex {
            return
        }
        
        self.oldPageIndex = self.curPageIndex
        self.curPageIndex = newPageIndex
        
        // item select index
        self.menuTabbar?.setCurrentIndex(newPageIndex)

        print(newPageIndex)
        
        // 부모한테 이벤트 처리
        if let delegate = self.delegate {
            if delegate.responds(to: #selector(delegate.containerViewItem(_:))) {
                delegate.containerViewItem(self.curPageIndex)
            }
        }
        
        displayScrollUI(scrollView)
    }
    
    // scrollView.scrollsToTop = YES 설정이 되어 있어야 아래 이벤트를 받을수 있다.
    // 스크롤뷰가 가장 위쪽으로 스크롤 되기 전에 실행된다. NO를 리턴할 경우 위쪽으로 스크롤되지 않도록 한다.
    //- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
    //{
    //    NSLog(@"scrollViewShouldScrollToTop");
    //    return YES;
    //}
    
    // 스크롤뷰가 가장 위쪽으로 스크롤 된 후에 실행된다.
    //- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
    //{
    //    NSLog(@"scrollViewDidScrollToTop");
    //}
    
    // 사용자가 콘텐츠 스크롤을 마쳤을 때 대리인에게 알립니다.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("scrollViewWillEndDragging:withVelocity:targetContentOffset:")
        
    }
}


extension ViewPagerContent: ViewPagerMenuDelegate {
    func scrollMenuViewSelected(_ index: Int) {
        
        // item select index
        self.menuTabbar?.setCurrentIndex(index)
        
        // 현재 선택된 페이지 인덱스와 같은 경우 더이상 처리하지 않는다.
        if self.curPageIndex == index {
            return
        }
        
        self.oldPageIndex = self.curPageIndex
        self.curPageIndex = index
        
        // 메뉴 컨텐츠 페이지 이동
        self.svContent.scrollRectToVisible(CGRect(x: CGFloat(index) * self.svContent.frame.width,
                                                  y: 0,
                                                  width: self.svContent.frame.width,
                                                  height: self.svContent.frame.height), animated: true)

        // 부모한테 이벤트 처리
        if let delegate = self.delegate {
            if delegate.responds(to: #selector(delegate.containerViewItem(_:))) {
                delegate.containerViewItem(self.curPageIndex)
            }
        }
    }
}
