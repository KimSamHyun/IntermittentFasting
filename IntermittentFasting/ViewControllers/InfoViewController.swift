//
//  InfoViewController.swift
//  IntermittentFasting
//
//  Created by Byunsangjin on 19/04/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var closeButton: UIImageView!
    @IBOutlet var closeView: UIView!
    
    
    
    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        closeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAlert)))
    }
    
    
    
    @objc func closeAlert() {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
}
