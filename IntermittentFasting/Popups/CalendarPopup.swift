//
//  CalendarPopup.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 26..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

class CalendarPopup: BasePopup {

    var year: Int = 2019
    var month: Int = 4
    @IBOutlet private weak var lbTitle: UILabel!
    
    private var confirmClick: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initGUI() {
        // 화면 갱신
        updateScreen()
    }
    
    // 화면 갱신
    func updateScreen() {
        self.lbTitle.text = "\(self.year)년 \(self.month)월"
    }
    
    func addActionConfirmClick(handler ConfirmClick: @escaping () -> Void) {
        confirmClick = ConfirmClick
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
    // 완료 버튼
    @IBAction func onConfirmClick(_ sender: Any) {
        callbackWithConfirm()
    }

    // 이전달 이동
    @IBAction func onPrevMonthClick(_ sender: Any) {
        let datePrev = CalendarManager.getYearMonth(year: self.year, month: self.month, amount: -1)
        self.year = datePrev.year
        self.month = datePrev.month
        
        // 화면 갱신
        updateScreen()
    }

    // 다음달 이동
    @IBAction func onNextMonthClick(_ sender: Any) {
        let dateNext = CalendarManager.getYearMonth(year: self.year, month: self.month, amount: 1)
        self.year = dateNext.year
        self.month = dateNext.month
        
        // 화면 갱신
        updateScreen()
    }

    // MARK: - Callback Event
    func callbackWithConfirm() {
        
        if let confirmAction = confirmClick {
            confirmAction()
        }
        
        removeFromParentVC()
    }

    // MARK: - Class Method
    /**
     message : 메세지
     */
    static func calendarPopup(yyyymm: String?) -> CalendarPopup {
        
        let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard
        let calendarVC = storyboard?.instantiateViewController(withIdentifier: "CalendarPopup") as? CalendarPopup
        // 팝업으로 떳을때
        calendarVC!.providesPresentationContextTransitionStyle = true
        calendarVC!.definesPresentationContext = true
        calendarVC!.modalPresentationStyle = .overFullScreen
        
        BasePopup.addChildVC(calendarVC)
        
        // 화면 초기화
        calendarVC!.initGUI()
        
        return calendarVC!
    }
}
