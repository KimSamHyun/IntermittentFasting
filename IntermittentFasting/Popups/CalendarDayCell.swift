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
        
        if CalendarManager.newSelectedDay == infoData.cellIndex {
            self.vSelectedCell.isHidden = false
        }
        else {
            self.vSelectedCell.isHidden = true
        }
    }
}
