//
//  CalendarPopup.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 26..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

class CalendarPopup: BasePopup, UICollectionViewDataSource {

    var curentYear: Int = 2019
    var curentMonth: Int = 4
    // 셀 갯수
    var arrDays: [DayInfo]?
    
    // 셀라인갯수
    var cellLineCount:Int = 0

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var confirmClick: ((_ year: Int, _ month: Int, _ day: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 선택 날짜 초기화
        CalendarManager.newSelectedDay = CalendarManager.curSelectedDay
        
        // 선택 날짜 초기화
        let YYYYMMDD: String = "\(CalendarManager.newSelectedDay)"
        self.curentYear = Int(YYYYMMDD.left(4))!
        self.curentMonth = Int(YYYYMMDD.mid(4, amount: 2))!
        
        // 화면 초기화
        initGUI()
    }
    
    override func initGUI() {
        // 년/월에 맞는 날짜 목록 얻어오기
        arrDays = CalendarManager.getMonthToDays(year: curentYear, month: curentMonth)
        cellLineCount = Int((arrDays?.count)! / 7)
        collectionViewHeightConstraint.constant = CGFloat(44 * cellLineCount)

        // 화면 갱신
        updateScreen()
    }
    
    // 화면 갱신
    func updateScreen() {
        self.lbTitle.text = "\(self.curentYear)년 \(self.curentMonth)월"
        
        // 콜렉션뷰 데이터 초기화
        self.collectionView.reloadData()
    }
    
    func addActionConfirmClick(handler ConfirmClick: @escaping (_ year: Int, _ month: Int, _ day: Int) -> Void) {
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
        // 선택 날짜 초기화
        CalendarManager.curSelectedDay = CalendarManager.newSelectedDay
        
        callbackWithConfirm()
    }

    // 이전달 이동
    @IBAction func onPrevMonthClick(_ sender: Any) {
        let datePrev = CalendarManager.getYearMonth(year: self.curentYear, month: self.curentMonth, amount: -1)
        self.curentYear = datePrev.year
        self.curentMonth = datePrev.month
        
        // 화면 초기화
        initGUI()
    }

    // 다음달 이동
    @IBAction func onNextMonthClick(_ sender: Any) {
        let dateNext = CalendarManager.getYearMonth(year: self.curentYear, month: self.curentMonth, amount: 1)
        self.curentYear = dateNext.year
        self.curentMonth = dateNext.month
        
        // 화면 초기화
        initGUI()
    }

    // MARK: - Callback Event
    func callbackWithConfirm() {
        
        if let confirmAction = confirmClick {
            
            // 선택 날짜 초기화
            let YYYYMMDD: String = "\(CalendarManager.curSelectedDay)"
            let year: Int = Int(YYYYMMDD.left(4))!
            let month: Int = Int(YYYYMMDD.mid(4, amount: 2))!
            let day: Int = Int(YYYYMMDD.right(2))!

            confirmAction(year, month, day)
        }
        
        removeFromParentVC()
    }
    
    // MARK: - UICollectionViewDataSource
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.arrDays == nil {
            return 0
        }
        
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if self.arrDays == nil {
            return 0
        }
        
        return self.arrDays!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CalendarDayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        if let arrDays = self.arrDays {
            let item: DayInfo = arrDays[indexPath.row]
            cell.setCellInfo(item)
            // Configure the cell
            //            cell.lbDay.text = "\(strValue)-\(indexPath.row+1)"
        }
        
        return cell
    }

    // MARK: - Class Method
    /**
     message : 메세지
     */
    static func calendarPopup() -> CalendarPopup {
        
        let storyboard: UIStoryboard? = AppDelegate.sharedNamedStroyBoard("Common") as? UIStoryboard
        let calendarVC = storyboard?.instantiateViewController(withIdentifier: "CalendarPopup") as? CalendarPopup
        // 팝업으로 떳을때
        calendarVC!.providesPresentationContextTransitionStyle = true
        calendarVC!.definesPresentationContext = true
        calendarVC!.modalPresentationStyle = .overFullScreen
        
        BasePopup.addChildVC(calendarVC)
        
        return calendarVC!
    }
}

extension CalendarPopup: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40.0, height: 44.0)
    }
    
    // 셀 선택
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item: DayInfo = arrDays![indexPath.row]
        // 선택한 날짜 설정
        CalendarManager.newSelectedDay = item.cellIndex

        // 이번달
        if item.monthDirection == 0 {
            // 화면 갱신
            updateScreen()
        }
        // 이전달, 다음달
        else {
            let datePrev = CalendarManager.getYearMonth(year: self.curentYear, month: self.curentMonth, amount: item.monthDirection)
            self.curentYear = datePrev.year
            self.curentMonth = datePrev.month
            
            // 화면 초기화
            initGUI()
        }
    }
}
