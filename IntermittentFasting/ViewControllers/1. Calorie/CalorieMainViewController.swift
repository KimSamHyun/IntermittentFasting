//
//  CalorieMainViewController.swift
//  IntermittentFasting
//
//  Created by sama73 on 2019. 4. 23..
//  Copyright © 2019년 Byunsangjin. All rights reserved.
//

import UIKit

class CalorieMainViewController: UIViewController {

    @IBOutlet weak var vWaveGage: WaveProgressView!
    @IBOutlet weak var lbCalorie: UILabel!
    @IBOutlet weak var sValue: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sValue.minimumValue = 0
        sValue.maximumValue = 1000
        sValue.setValue(820, animated: false)
        
        if let waveView = self.vWaveGage {
            waveView.waveRate = 2
            waveView.waveSpeed = 1
            waveView.waveHeight = 5
            
            waveView.minimumValue = sValue.minimumValue;
            waveView.maximumValue = sValue.maximumValue;
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
        
        // GUI 초기화
        vWaveGage!.initGUI(color: UIColor.init(hex: 0x60DDB4))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.vWaveGage!.updateFrame(value: sender.value)
    }

}
