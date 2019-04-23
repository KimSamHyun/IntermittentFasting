//
//  TabbarViewController.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 22..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

// 탭바 컨트롤
struct TabbarControll {
    var btnTab: UIButton? = nil
    var lbTabTitle: UILabel? = nil
    var viewControllers: UIViewController? = nil
}

class TabbarViewController: UIViewController {
    
    // 이전 선택 탭인덱스
    var previousIndex:Int = 0
    // 선택 탭인덱스
    var selectedIndex:Int = -1
    
    var arrTabbarControll: [TabbarControll] = []

    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var vTabbar: UIView!
    
    @IBOutlet weak var btnTab0: UIButton!
    @IBOutlet weak var btnTab1: UIButton!
    @IBOutlet weak var btnTab2: UIButton!
    @IBOutlet weak var btnTab3: UIButton!
    @IBOutlet weak var btnTab4: UIButton!
    
    @IBOutlet weak var lbTabTitle0: UILabel!
    @IBOutlet weak var lbTabTitle1: UILabel!
    @IBOutlet weak var lbTabTitle2: UILabel!
    @IBOutlet weak var lbTabTitle3: UILabel!
    @IBOutlet weak var lbTabTitle4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 탭바 그림자 처리
        vTabbar.layer.masksToBounds = false
        vTabbar.layer.shadowColor = UIColor.black.cgColor
        vTabbar.layer.shadowOffset = CGSize(width: 0, height: -5)
        vTabbar.layer.shadowOpacity = 0.03
        
        // 탭 메인 VC 로드
        let calorieVC = self.storyboard?.instantiateViewController(withIdentifier: "CalorieMainViewController") as? CalorieMainViewController
        let weightVC = self.storyboard?.instantiateViewController(withIdentifier: "WeightMainViewController") as? WeightMainViewController
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeMainViewController") as? HomeMainViewController
        let boardVC = self.storyboard?.instantiateViewController(withIdentifier: "BoardMainViewController") as? BoardMainViewController
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsMainViewController") as? SettingsMainViewController

        // 탭컨트롤러 정보 세팅
        let tc0: TabbarControll = TabbarControll(btnTab: btnTab0, lbTabTitle: lbTabTitle0, viewControllers: calorieVC)
        arrTabbarControll += [tc0]
        let tc1: TabbarControll = TabbarControll(btnTab: btnTab1, lbTabTitle: lbTabTitle1, viewControllers: weightVC)
        arrTabbarControll += [tc1]
        let tc2: TabbarControll = TabbarControll(btnTab: btnTab2, lbTabTitle: lbTabTitle2, viewControllers: homeVC)
        arrTabbarControll += [tc2]
        let tc3: TabbarControll = TabbarControll(btnTab: btnTab3, lbTabTitle: lbTabTitle3, viewControllers: boardVC)
        arrTabbarControll += [tc3]
        let tc4: TabbarControll = TabbarControll(btnTab: btnTab4, lbTabTitle: lbTabTitle4, viewControllers: settingsVC)
        arrTabbarControll += [tc4]
        
        // 탭 선택
        selectedTab(0)
    }
    
    // 탭 선택 - 버튼 선택 처리
    func selectedTab(_ index: NSInteger) {
        previousIndex = selectedIndex
        selectedIndex = index
        
        // 이전 Tab Index와 같으면
        if previousIndex == selectedIndex {
            return
        }
        
        // 이전탭 해제
        if previousIndex != -1 {
            let tc: TabbarControll = arrTabbarControll[previousIndex]
            tc.viewControllers!.view.removeFromSuperview()
            tc.viewControllers!.removeFromParent()
        }

        for i in 0..<arrTabbarControll.count {
            let tc: TabbarControll = arrTabbarControll[i]
            if i == index {
                tc.btnTab!.isSelected = true
                tc.lbTabTitle!.textColor = UIColor.init(hex: 0xFF7F67)
                
                if let vc = tc.viewControllers {
                    // 탭 VC 설정
                    self.addChild(vc)
                    
                    vc.view.frame = self.vContent.bounds
                    self.vContent.addSubview(vc.view)
                }
            }
            else {
                tc.btnTab!.isSelected = false
                tc.lbTabTitle!.textColor = UIColor.init(hex: 0xAEAEAE)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIButton Action
    @IBAction func onTabClick(_ sender: UIButton) {
        // 탭 선택
        selectedTab(sender.tag)
    }
}
