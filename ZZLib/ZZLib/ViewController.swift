//
//  ViewController.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/2.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

class Test {
    
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()


        let btn = UIButton(frame: CGRect(x: 20, y: 80, width: 100, height: 40))
        btn.backgroundColor = .blue
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        let b = Bundle(for: Test.self)
        let bt = b.path(forResource: "Test", ofType: "bundle")
        print(b, bt)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(ViewController(), animated: true)
        zz_application.open(URL(string: "https://itunes.apple.com/app/id444934666")!, options: ["": ""]) { (v) in
            print(v)
        }
    }
    var timer: Timer?
    @objc func click() {
        Timer.zz_scheduledTimer(timeInterval: 1, target: self, selector: #selector(run), userInfo: nil, repeats: true)
    }
    
    @objc func run() {
        print("----------")
    }
    
}


class ZZSafeTimer {
    weak var target: AnyObject?
    var selector: Selector?
    var timer: Timer?
    
    class func scheduledTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> Timer {
        let safeTimer = ZZSafeTimer()
        safeTimer.target = aTarget as AnyObject
        safeTimer.selector = aSelector
        safeTimer.timer = Timer.scheduledTimer(timeInterval: ti, target: safeTimer, selector: #selector(fire), userInfo: userInfo, repeats: yesOrNo)
        return safeTimer.timer!
    }
    
    @objc func fire() {
        if let target = target {
            target.perform(selector, with: timer?.userInfo)
        } else {
            timer?.invalidate()
        }
    }
}

