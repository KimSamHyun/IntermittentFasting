//
//  TabbarViewController.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 22..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

class TabbarViewController: UIViewController {
    
    // 이전 선택 탭인덱스
    var previousIndex:Int = 0
    // 선택 탭인덱스
    var selectedIndex:Int = -1
    
    var arrTabbarButton: [UIButton] = []
    var arrTabbarLabel: [UILabel] = []

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
        vTabbar.layer.shadowOffset = CGSize(width: 0, height: -10)
        vTabbar.layer.shadowOpacity = 0.11

        // 탭바 버튼
        arrTabbarButton += [btnTab0]
        arrTabbarButton += [btnTab1]
        arrTabbarButton += [btnTab2]
        arrTabbarButton += [btnTab3]
        arrTabbarButton += [btnTab4]
        
        // 탭바 타이틀
        arrTabbarLabel += [lbTabTitle0]
        arrTabbarLabel += [lbTabTitle1]
        arrTabbarLabel += [lbTabTitle2]
        arrTabbarLabel += [lbTabTitle3]
        arrTabbarLabel += [lbTabTitle4]
        
        // 탭 선택
        selectedTab(0)
    }
    
    // 탭 선택 - 버튼 선택 처리
    func selectedTab(_ index: NSInteger) {
        for i in 0..<arrTabbarButton.count {
            let btnTab: UIButton = arrTabbarButton[i]
            let lbTabTitle: UILabel = arrTabbarLabel[i]
            if i == index {
                btnTab.isSelected = true
                lbTabTitle.textColor = UIColor.init(hex: 0xFF7F67)
            }
            else {
                btnTab.isSelected = false
                lbTabTitle.textColor = UIColor.init(hex: 0xAEAEAE)
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
        previousIndex = selectedIndex
        selectedIndex = sender.tag

        // 이전 Tab Index와 같으면
        if previousIndex == selectedIndex {
            return
        }
        
        // 탭 선택
        selectedTab(selectedIndex)
    }
}
