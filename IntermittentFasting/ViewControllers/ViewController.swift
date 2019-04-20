//
//  ViewController.swift
//  IntermittentFasting
//
//  Created by Byunsangjin on 15/04/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var startButton: UIButton!
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK:- Actions
    @IBAction func infoBtnClick(_ sender: Any) {
        let infoPageVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        
        self.addChild(infoPageVC)
        self.view.addSubview(infoPageVC.view)
    }
    
    
    
    @IBAction func startBtnClick(_ sender: Any) {
        let inputInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "InputInfoViewController") as! InputInfoViewController
        
        self.present(inputInfoVC, animated: true)
    }
}

