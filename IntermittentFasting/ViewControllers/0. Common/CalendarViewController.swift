//
//  CalendarViewController.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 26..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    // 완료
    @IBAction func onCompleteClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
