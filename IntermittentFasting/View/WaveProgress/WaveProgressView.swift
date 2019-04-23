//
//  WaveProgressView.swift
//  LCWaveViewExample
//
//  Created by sama73 on 2019. 4. 15..
//  Copyright © 2019년 LC. All rights reserved.
//

import UIKit

// 웨이브 커브 애니메이션보기
// 웨이브 커브 공식：y = h * sin(a * x + b);
// h: 파도 높이， a: 웨이브 폭 계수， b： 변동 옵셋

/// 웨이브 뷰
class WaveProgressView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    // MARK: - 공공 재산
    
    /// 웨이브 폭 계수 -> a
    public var waveRate: CGFloat = 1.5
    
    /// 변동 속도 (기본값 : 0.5 값 0 ~ 1)
    public var waveSpeed: CGFloat = 0.5
    
    /// 변동의 높이 -> h (기본값 : 5)
    public var waveHeight: CGFloat = 5
    
    // default 0.0. this value will be pinned to min/max
    public var value: Float = 0
    
    // default 0.0. the current value may change if outside new min value
    public var minimumValue: Float = 0
    
    // default 1.0. the current value may change if outside new max value
    public var maximumValue: Float = 1
    
    /// 트루 웨이브 레이어 색상
    public var realWaveColor: UIColor = UIColor.white {
        didSet {
            realWaveLayer.fillColor = realWaveColor.cgColor
        }
    }
    /// 마스크 웨이브 레이어 색상
    public var maskWaveColor: UIColor = UIColor.white {
        didSet {
            maskWaveLayer.fillColor = maskWaveColor.cgColor
        }
    }
    
    /// 변동 완료 콜백
    public var completion: ((_ centerY: CGFloat)->())?
    
    
    // MARK: - 비공개 특성
    
    /// 트루 웨이브 레이어
    private lazy var realWaveLayer: CAShapeLayer = CAShapeLayer()
    
    /// 마스크 웨이브 레이어
    private lazy var maskWaveLayer: CAShapeLayer = CAShapeLayer()
    
    /// 화면 새로 고침 빈도 타이머
    private var waveDisplayLink: CADisplayLink?
    
    /// 웨이브 옵셋 -> b
    private var offset: CGFloat = 0
    
    /// 주파수
    private var priFrequency: CGFloat = 0
    
    /// 속도
    private var priWaveSpeed: CGFloat = 0
    
    /// 높이
    private var priWaveHeight: CGFloat = 0
    
    /// 변수 기록 변동보기의 상태 정의 - 시작 (기본값 : false)
    private var isStarting: Bool = false
    
    /// 변수 기록 변동보기의 상태를 정의하십시오 - 정지 (기본값 :false)
    private var isStopping: Bool = false
    
    
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    // MARK: - 편리한 생성자
    
    /// 웨이브 뷰의 크기 위치와 색상을 초기화합니다.
    ///
    /// - Parameters:
    ///   - frame: 크기 위치
    ///   - color: 색상
    convenience init(frame: CGRect, color: UIColor) {
        self.init(frame: frame)

        // GUI 초기화
        initGUI(color: color)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // GUI 초기화
    func initGUI(color: UIColor) {
        var tempf = bounds
        
        // 물결 색상
        let percent = setWaveColor()

        let y: CGFloat = tempf.height - percent * tempf.height
        tempf.origin.y = y
        tempf.size.height = 0
        
        maskWaveLayer.frame = tempf
        realWaveLayer.frame = tempf
        
        backgroundColor = .clear
        layer.addSublayer(realWaveLayer)
        layer.addSublayer(maskWaveLayer)
        
        realWaveColor = color
        maskWaveColor = color.withAlphaComponent(0.5)
        realWaveLayer.fillColor = realWaveColor.cgColor     // 레이어 채우기 색상
        maskWaveLayer.fillColor = maskWaveColor.cgColor
    }
    
    // 물결 색상
    func setWaveColor() -> CGFloat {
        let percent = value / maximumValue
        /*
        if percent > 0.9 {
            let color = UIColor.red
            realWaveColor = color
            maskWaveColor = color.withAlphaComponent(0.5)
            realWaveLayer.fillColor = realWaveColor.cgColor     // 레이어 채우기 색상
            maskWaveLayer.fillColor = maskWaveColor.cgColor
        }
        else if percent > 0.7 {
            let color = UIColor.orange
            realWaveColor = color
            maskWaveColor = color.withAlphaComponent(0.5)
            realWaveLayer.fillColor = realWaveColor.cgColor     // 레이어 채우기 색상
            maskWaveLayer.fillColor = maskWaveColor.cgColor
        }
        else {
            let color = UIColor.blue
            realWaveColor = color
            maskWaveColor = color.withAlphaComponent(0.5)
            realWaveLayer.fillColor = realWaveColor.cgColor     // 레이어 채우기 색상
            maskWaveLayer.fillColor = maskWaveColor.cgColor
        }
 */
        
        return CGFloat(percent)
    }
    
    // 프레임 갱신
    // value 게이지값
    func updateFrame(value: Float) {
        var tempf = bounds
        
        // 물결 색상
        let percent = setWaveColor()
        let y: CGFloat = tempf.height - percent * tempf.height
        self.value = value
        tempf.origin.y = y
        tempf.size.height = 0
        
        maskWaveLayer.frame = tempf
        realWaveLayer.frame = tempf
        
        other()
    }
}

// MARK: - Method
extension WaveProgressView {
    /// 웨이브 시작
    public func startWave() {
        
        if !isStarting {
            
            removeTimer()   // 먼저 화면 주사율 타이머를 제거하십시오.
            isStarting = true
            isStopping = false
            
            /*   CADisplayLink:동일한 화면 새로 고침 빈도를 가진 타이머를 특정 모드의 runloop에 등록해야합니다. 화면을 새로 고칠 때마다 바운드 대상의 선택기가 호출됩니다.
             duration:프레임 간 시간
             pause:일시 중지하려면 true로 설정하고 계속하려면 false로 설정하십시오.
             마지막에 invalidate 메소드를 호출하고 이전에 바인딩 된 타겟과 셀렉터를 runloop에서 제거해야합니다.
             상속 될 수 없다.
             */
            // 타이머 켜기
            waveDisplayLink = CADisplayLink(target: self, selector: #selector(waveEvent))
            waveDisplayLink?.add(to: .current, forMode: RunLoop.Mode.common)
        }
    }
    
    /// 변동을 멈추십시오.
    public func stopWave() {
        if !isStopping {
            isStarting = false
            isStopping = true
        }
    }
    
    /// 타이머 삭제
    private func removeTimer() {
        // 실행 루프에서 타이머를 제거하십시오.
        waveDisplayLink?.invalidate()
        waveDisplayLink = nil
    }
    
    /// 떠 다니는 사건
    @objc func waveEvent() {
        
        if isStarting {
            BeganToWave()
        }
        if isStopping {
            endToWave()
        }
        
        other()
    }
}

// MARK: - 세 가지 부동 상태 (시작, 끝, 기타)
extension WaveProgressView {
    /// 변동하기 시작하다.
    private func BeganToWave() {
        guard priWaveHeight < waveHeight else {
            isStarting = false
            return
        }
        
        priWaveHeight = priWaveHeight + waveHeight / 100
        
        // 1.임시 변수를 사용하여 현재보기 크기 저장
        var f = self.bounds
        
        // 2.이 변수에 값 지정
        let y: CGFloat = f.height - CGFloat(value / maximumValue) * f.height
        f.origin.y = y - priWaveHeight
        f.size.height = priWaveHeight
        
        // 3.frame 값 수정
        maskWaveLayer.frame = f
        realWaveLayer.frame = f
        priFrequency = priFrequency + waveRate / 100
        priWaveSpeed = priWaveSpeed + waveSpeed / 100
    }
    
    /// 변동 종료
    private func endToWave() {
        guard priWaveHeight > 0 else {  // 멈추다
            isStopping = false
            stopWave()
            return
        }

        priWaveHeight = priWaveHeight - waveHeight / 50.0
        
        // 1.임시 변수를 사용하여 현재보기 크기 저장
        var f = self.bounds
        
        // 2.이 변수에 값 지정
        let y: CGFloat = f.height - CGFloat(value / maximumValue) * f.height
        f.origin.y = y
        f.size.height = priWaveHeight
        
        // 3.frame 값 수정
        maskWaveLayer.frame = f
        realWaveLayer.frame = f
        priFrequency = priFrequency - waveRate / 50.0
        priWaveSpeed = priWaveSpeed - waveSpeed / 50.0
    }
    
    /// 기타 상황
    private func other() {
        
        // 웨이브 이동의 열쇠 : 지정된 속도로 오프셋
        offset += priWaveSpeed
        
        var isWaveAnimation: Bool = true
        // 최소값이나 최대값과 같을 경우 파동을 없앤다.
        if value == minimumValue || value == maximumValue {
            isWaveAnimation = false
        }
        
        let width: CGFloat = frame.width
        let height: CGFloat = isWaveAnimation ? priWaveHeight : 0
        
        
        // 변수 그래픽 경로 1, 2 만들기
        let realPath = CGMutablePath()
        let maskPath = CGMutablePath()
        
        // 새 하위 경로를 지정하기 시작합니다
        realPath.move(to: CGPoint(x: 0, y: height))
        
        // sama73 : 물결 밑에 영역 채우기
        realPath.addLine(to: CGPoint(x: width, y: height))
        realPath.addLine(to: CGPoint(x: width, y: frame.height))
        realPath.addLine(to: CGPoint(x: 0, y: frame.height))
        realPath.addLine(to: CGPoint(x: 0, y: height))
        
        maskPath.move(to: CGPoint(x: 0, y: height))

        if isWaveAnimation == true {
            let offset_f = Float(offset * 0.045)
            
            let waveFrequency_f = Float(0.01 * priFrequency)
            
            for x in 0...Int(width) {
                
                // 파동 곡선
                let y = height * CGFloat(sin(waveFrequency_f * Float(x) + offset_f))
                
                // 첫 번째 양식의 형태로이 점을 그립니다.
                realPath.addLine(to: CGPoint(x: CGFloat(x), y: y))
                maskPath.addLine(to: CGPoint(x: CGFloat(x), y: -y))
            }
        }

        // 아바타 물결 중앙 값
//        let midX = bounds.size.width * 0.5
//        let midY = height * sin(midX * CGFloat(waveFrequency_f) + CGFloat(offset_f))
        
        // 퍼센트 반환값
        if let callback = completion {
            let pecent: CGFloat = CGFloat(value / maximumValue * 100)
            callback(pecent)
//            callback(midY)
        }
        
        // 1.현재 점에서 지정된 점까지의 선의 형태로 패스를 그립니다.
        realPath.addLine(to: CGPoint(x: width, y: height))
        realPath.addLine(to: CGPoint(x: 0, y: height))
        maskPath.addLine(to: CGPoint(x: width, y: height))
        maskPath.addLine(to: CGPoint(x: 0, y: height))
        // 2.경로 닫기
        maskPath.closeSubpath()
        realPath.closeSubpath()
        // 3.배정 경로
        realWaveLayer.path = realPath
        maskWaveLayer.path = maskPath
    }
}
