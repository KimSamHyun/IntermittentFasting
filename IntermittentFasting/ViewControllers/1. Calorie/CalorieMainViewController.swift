//
//  CalorieMainViewController.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 23..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

class CalorieMainViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vWaveGage: WaveProgressView!
    @IBOutlet weak var lbCalorie: UILabel!
    @IBOutlet weak var sValue: UISlider!
    @IBOutlet weak var btnFoodAdd: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 오늘 날짜 선택 날짜 초기화
        CalendarManager.curSelectedDay = CalendarManager.getTodayIndex()
        CalendarManager.newSelectedDay = CalendarManager.curSelectedDay

        sValue.minimumValue = 0
        sValue.maximumValue = 1640
        sValue.setValue(820, animated: false)
        
        if let waveView = self.vWaveGage {
            waveView.waveRate = 2
            waveView.waveSpeed = 1
            waveView.waveHeight = 5
            
            waveView.minimumValue = sValue.minimumValue;
            waveView.maximumValue = sValue.maximumValue;
            waveView.limitValue = 1300
            waveView.value = sValue.value
            
            // 웨이프 프로그레스 원
            waveView.layer.masksToBounds = true
            waveView.layer.borderColor = UIColor.init(hex: 0x60DDB4).cgColor
            waveView.layer.borderWidth = 1
            waveView.layer.cornerRadius = 107
            
            waveView.completion = { percent in  // 웨이브 애니메이션 콜백
                self.lbCalorie.text = "\(Int(waveView.value))"
                // 아바타보기의 y 좌표를 동기화하십시오
                //                self.iconImageView.frame.origin.y = waveViewHeight + centerY - iconImageWidth
            }
            //            waveView.addSubview(iconImageView)
            waveView.startWave()
        }
        
        // 음식 추가 버튼 그림자
        btnFoodAdd.layer.shadowColor = UIColor(hex: 0xFF7F67).cgColor
        btnFoodAdd.layer.shadowOffset = CGSize(width: 0, height: 4)
        btnFoodAdd.layer.shadowOpacity = 0.35
        
        // GUI 초기화
        vWaveGage!.initGUI(color: UIColor.black)
//        vWaveGage!.initGUI(color: UIColor.init(hex: 0x60DDB4))
        
        // 화면 갱신
        updateScreen()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 화면 갱신
    func updateScreen() {
        // 선택한 날짜가 오늘날짜와 동일한 경우
        if CalendarManager.getTodayIndex() == CalendarManager.curSelectedDay {
            self.lbTitle.text = "Today"
        }
        else {
            // 선택 날짜 초기화
            let YYYYMMDD: String = "\(CalendarManager.curSelectedDay)"
            let year: Int = Int(YYYYMMDD.left(4))!
            let month: Int = Int(YYYYMMDD.mid(4, amount: 2))!
            let day: Int = Int(YYYYMMDD.right(2))!
            
            self.lbTitle.text = String.init(format: "%d. %02d. %02d", year, month, day)
        }
    }

    // MARK: - Action
    // 달력 팝업
    @IBAction func onCalendarClick(_ sender: UIButton) {
        let popupVC = CalendarPopup.calendarPopup()
        popupVC.addActionConfirmClick { (year, month, day) in
            // 화면 갱신
            self.updateScreen()
        }
    }
    
    // 음식 추가
    @IBAction func onFoodAddClick(_ sender: UIButton) {
        if let storyboard = AppDelegate.sharedNamedStroyBoard("Calorie") as? UIStoryboard {
            
            let foodAddVC: FoodAddViewController = storyboard.instantiateViewController(withIdentifier: "FoodAddViewController") as! FoodAddViewController
            self.present(foodAddVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.vWaveGage!.updateFrame(value: sender.value)
    }

}
