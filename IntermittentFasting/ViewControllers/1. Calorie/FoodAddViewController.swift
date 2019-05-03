//
//  FoodAddViewController.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 29..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

class FoodAddViewController: UIViewController {

    @IBOutlet weak var viewPager: ViewPagerContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Calorie") as? UIStoryboard
        let foodFindVC = storyboard?.instantiateViewController(withIdentifier: "FoodFindViewController") as? FoodFindViewController
        foodFindVC!.title = "음식검색"
        let personalFoodVC = storyboard?.instantiateViewController(withIdentifier: "PersonalFoodViewController") as? PersonalFoodViewController
        personalFoodVC!.title = "개인음식"
        let bookMarkVC = storyboard?.instantiateViewController(withIdentifier: "BookMarkViewController") as? BookMarkViewController
        bookMarkVC!.title = "즐겨찾기"
        
        var viewPagerInfo: ViewPagerInfo = ViewPagerInfo(menuButtonColorNormal: UIColor(hex: 0x000000),
                                                         menuButtonColorSelected: UIColor(hex: 0x60DDB4),
                                                         menuButtonfontSize: 19.0,
                                                         menuButtonHeight: 45.0,
                                                         menuButtonOffsetX: 11.0)
        
        viewPagerInfo.arrChildController = [foodFindVC!, personalFoodVC!, bookMarkVC!]
        
        // 뷰페이저 초기화
        self.viewPager!.initContent(viewPagerInfo)
        
        self.viewPager!.delegate = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Action
    // 닫기
    @IBAction func onCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FoodAddViewController: ViewPagerContentDelegate {
    func containerViewItem(_ index: Int) {
        print("메인화면 이벤트=\(index)")
        
    }
}
