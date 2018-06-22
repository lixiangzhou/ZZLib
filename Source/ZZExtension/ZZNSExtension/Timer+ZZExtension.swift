//
//  Timer+ZZExtension.swift
//  ZZLib
//
//  Created by lxz on 2018/6/22.
//  Copyright © 2018年 lixiangzhou. All rights reserved.
//

import Foundation

public extension Timer {
    
    class ZZSafeTarget {
        weak var target: AnyObject?
        var selector: Selector?
        weak var timer: Timer?
        
        @objc func fire() {
            if let target = target {
                _ = target.perform(selector, with: timer?.userInfo)
            } else {
                timer?.invalidate()
            }
        }
    }
    
    @discardableResult
    class func zz_scheduledTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) -> Timer {
        let safeTarget = ZZSafeTarget()
        safeTarget.target = aTarget as AnyObject
        safeTarget.selector = aSelector
        safeTarget.timer = Timer.scheduledTimer(timeInterval: ti, target: safeTarget, selector: #selector(ZZSafeTarget.fire), userInfo: userInfo, repeats: yesOrNo)
        return safeTarget.timer!
    }
}
