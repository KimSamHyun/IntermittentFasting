//
//  CalendarDayCell.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 29..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

class CalendarDayCell: UICollectionViewCell {
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var vSelectedCell: RoundLineView!

    func setCellInfo(_ infoData: DayInfo) {
        self.lbDay.text = "\(infoData.day)"
        
        // 이번달
        if infoData.monthDirection == 0 {
            self.lbDay.textColor = UIColor.init(hex: 0x000000, alpha: 0.5)
        }
        // 이전달, 다음달
        else {
            self.lbDay.textColor = UIColor.init(hex: 0x000000, alpha: 0.2)
        }
        
        if CalendarManager.newSelectedDay == infoData.cellIndex {
            self.vSelectedCell.isHidden = false
        }
        else {
            self.vSelectedCell.isHidden = true
        }
    }
}
