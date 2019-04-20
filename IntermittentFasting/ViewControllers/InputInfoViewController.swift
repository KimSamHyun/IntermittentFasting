//
//  InputInfoViewController.swift
//  IntermittentFasting
//
//  Created by Byunsangjin on 19/04/2019.
//  Copyright © 2019 Byunsangjin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputInfoViewController: UIViewController {
    // MARK:- Outlets
    @IBOutlet var genderButton: [ButtonLayer]!
    
    @IBOutlet var heightTextField: TextFieldLayer!
    @IBOutlet var weightTextField: TextFieldLayer!
    
    @IBOutlet var heightWarningImg: UIImageView!
    @IBOutlet var weightWarningImg: UIImageView!
    
    
    
    // MARK:- Variables
    var disposeBag = DisposeBag()
    
    

    // MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }
    
    
    
    func setUI() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        heightTextField.rx.text.orEmpty
            .map(isTextFieldEmpty)
            .subscribe(onNext: { b in
                self.heightWarningImg.isHidden = !b
            }).disposed(by: disposeBag)
        
        weightTextField.rx.text.orEmpty
            .map(isTextFieldEmpty)
            .subscribe(onNext: { b in
                self.weightWarningImg.isHidden = !b
            }).disposed(by: disposeBag)
    }
    
    
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    func isTextFieldEmpty(text: String) -> Bool {
        print("isEmpty \(text.isEmpty)")
        return text.isEmpty
    }
    
    
    
    // MARK:- Actions
    @IBAction func backBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func genderBtnClick(_ sender: ButtonLayer) {
        let selectColor = UIColor(hexString: "60DDB4")
        let unSelectTextColor = UIColor.black
        let unSelectBorderColor = UIColor(hexString: "B6B6B6")
        
        genderButton.forEach { (button) in
            if button.tag == sender.tag { // 선택한 버튼
                button.borderColor = selectColor
                button.setTitleColor(selectColor, for: .normal)
            } else { // 선택하지 않은 버튼
                button.borderColor = unSelectBorderColor
                button.setTitleColor(unSelectTextColor, for: .normal)
            }
        }
    }
}
