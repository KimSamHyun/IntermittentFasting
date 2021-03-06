//
//  CalendarManager.swift
//  PlannerDiary
//
//  Created by 김삼현 on 13/01/2019.
//  Copyright © 2019 sama73. All rights reserved.
//

import UIKit
import Foundation

// 날짜 정보
struct DayInfo {
    var year: Int
    var month: Int
    var day: Int
    // year * 10000 + month * 100 + day
    var cellIndex: Int
    // 보여주는 월의 이전(-1), 현재(0), 다음달(1) 표시
    var monthDirection: Int
    // 일요일
    var isHoliday: Bool
    
    init(year: Int,
         month: Int,
         day: Int,
         cellIndex: Int,
         monthDirection: Int,
         isHoliday: Bool = false) {
        
        self.year = year
        self.month = month
        self.day = day
        self.cellIndex = cellIndex
        self.monthDirection = monthDirection
        self.isHoliday = isHoliday
    }
}

class CalendarManager {
    
    // 날짜 선택
    static var curSelectedDay: Int = -1
    static var newSelectedDay: Int = -1
		
	// 월간 문자
	static func getMonthString(monthIndex:Int) -> String {
		if monthIndex < 1 || monthIndex > 12 {
			return ""
		}
		
		let arrMonthTitle: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
		
		return arrMonthTitle[monthIndex-1]
	}
	
	// 주간 긴문자
	static func getWeekFullString(weekIndex:Int) -> String {
		if weekIndex < 0 || weekIndex > 6 {
			return ""
		}
		
		let arrWeekTitle: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
		
		return arrWeekTitle[weekIndex]
	}
	
    // 오늘날짜 인덱스를 구해준다.
    static func getTodayIndex() -> Int {
        // 오늘날짜로 년월일을 구해준다.
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

		return (year * 10000 + month * 100 + day)
    }
	
    // 이번달 기준으로 value값을 가감 계산해준다.
    static func getYearMonth(amount:Int) -> (year:Int, month:Int) {
        // 오늘날짜로 년월일을 구해준다.
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        return getYearMonth(year: year, month: month, amount: amount)
    }
    
    // 선택한 년/월에서 계산해서 새로운 년/월을 반환해준다.
    static func getYearMonth(year:Int, month:Int, amount:Int) -> (year:Int, month:Int) {
        
        // 반복 횟수
        var loopCount = amount
        // 더할것인가?
        var isInc = true
        if loopCount < 0 {
            loopCount *= -1
            isInc = false
        }
        var newYear: Int = year
        var newMonth: Int = month
        
        for _ in 0..<loopCount {
            if isInc == true {
                newMonth += 1
            }
            else {
                newMonth -= 1
            }
            
            // 현재 월이 1월일 경우
            if newMonth < 1 {
                newYear -= 1
                newMonth = 12
            }
            
            // 현재 월이 12월일 경우
            if newMonth > 12 {
                newYear += 1
                newMonth = 1
            }
        }
        
        return (newYear, newMonth)
    }
    
    // 년/월에 맞는 날짜 목록 얻어오기
    static func getMonthToDays(year:Int, month:Int) -> [DayInfo] {
                
        // 선택한 달의 날짜 목록
        var arrCurentMoth:[DayInfo] = []
        
        // 이번달
        let curYear: Int = year
        let curMonth: Int = month
        
        // 이전달
        var prevYear: Int = year
        var prevMonth: Int = curMonth - 1
        // 현재 월이 1월일 경우
        if prevMonth < 1 {
            prevMonth = 12
            prevYear = year - 1
        }
        
        // 다음달
        var nextYear: Int = year
        var nextMonth: Int = curMonth + 1
        // 현재 월이 12월일 경우
        if nextMonth > 12 {
            nextMonth = 1
            nextYear = year + 1
        }
        
        
        // 공휴일 정보 체크
        // 선택한 년/월 인덱스
//        let curIndex = curYear * 100 + curMonth
//        let prevIndex = prevYear * 100 + prevMonth
//        let nextIndex = nextYear * 100 + nextMonth
        
        // 이전달 정보
        var comps = DateComponents()
        comps.year = prevYear
        comps.month = prevMonth
        comps.day = 1
        
        let calendar = Calendar.current
        var date: Date? = calendar.date(from: comps)
        
        var range: Range<Int>? = nil
        if let date = date {
            range = calendar.range(of: .day, in: .month, for: date)
        }
        // 이전달 날짜수
        let prevMothDayLength = range!.count
        
        // 이번달 정보
        comps.year = curYear
        comps.month = curMonth
        comps.day = 1
        
        date = calendar.date(from: comps)
        if let date = date {
            range = calendar.range(of: .day, in: .month, for: date)
        }
        // 이번달 날짜수
        let curMothDayLength = range!.count
        
        var comp: DateComponents? = nil
        if let date = date {
            comp = calendar.dateComponents([.weekday], from: date)
        }
        
        // 0:일, 1:월 ... 6:토
        let weekday: Int = comp!.weekday! - 1

        var dayCount = 0
        
        // 이전달
        var countDay: Int = prevMothDayLength - weekday
        for _ in 0..<weekday {
            countDay += 1
            
            let cellIndex = prevYear * 10000 + prevMonth * 100 + countDay
            var dayInfo: DayInfo = DayInfo(year: prevYear,
                                           month: prevMonth,
                                           day: countDay,
                                           cellIndex: cellIndex,
                                           monthDirection: -1)
            // 일요일 체크
            if (dayCount % 7) == 0 {
                dayInfo.isHoliday = true
            }
            else {
                dayInfo.isHoliday = false
            }

            arrCurentMoth.append(dayInfo)
            
            dayCount += 1
        }
        
        // 이번달
        countDay = 0
        for _ in 0..<curMothDayLength {
            countDay += 1

            let cellIndex = curYear * 10000 + curMonth * 100 + countDay
            var dayInfo: DayInfo = DayInfo(year: curYear,
                                           month: curMonth,
                                           day: countDay,
                                           cellIndex: cellIndex,
                                           monthDirection: 0)

            // 일요일 체크
            if (dayCount % 7) == 0 {
                dayInfo.isHoliday = true
            }
            else {
                dayInfo.isHoliday = false
            }
            
            arrCurentMoth.append(dayInfo)
                        
            dayCount += 1
        }

        // 다음달
        let mod: Int = arrCurentMoth.count % 7
        if mod > 0 {
            let gep: Int = 7 - (arrCurentMoth.count % 7)
            countDay = 0
            for _ in 0..<gep {
                countDay += 1

                let cellIndex = nextYear * 10000 + nextMonth * 100 + countDay
                let dayInfo: DayInfo = DayInfo(year: nextYear,
                                               month: nextMonth,
                                               day: countDay,
                                               cellIndex: cellIndex,
                                               monthDirection: 1,
                                               isHoliday: false)
                
                arrCurentMoth.append(dayInfo)
            }
        }

        return arrCurentMoth
    }
}
