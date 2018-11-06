//
//  NSNumber+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/8/8.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import Foundation

public extension NSNumber {
    /// 是否Bool值
    var zz_isBool: Bool {
        return CFBooleanGetTypeID() == CFGetTypeID(self)
    }
}

public extension Int {
    
    /// 从低位到高位，从左到右，获取对应索引的数字
    ///
    /// - Parameter idx: 索引
    subscript(idx: UInt) -> Int? {
        var decimalBase = 1
        for _ in 0..<idx {
            decimalBase *= 10
        }
        
        if decimalBase > self {
            return nil
        }
        
        return (self / decimalBase) % 10
    }
    
    
    /// 返回整数的长度，不包括正负符号
    var zz_length: Int {
        return "\(self)".count - (self < 0 ? 1 : 0)
    }
}

public extension Double {
    /// 四舍六入规则：
    /// 四舍六入五考虑，五后非零则进一，五后皆零看奇偶，五前偶舍奇进一
    func zz_46Value(point: UInt) -> Double {
        let components = self.description.split(separator: ".")
        // 判断是否有小数
        guard let floatValueString = components.last,
            let intValueString = components.first,
            floatValueString.count > point else {
            return self
        }
        
        let startIdx = floatValueString.startIndex
        let midIdx = floatValueString.index(startIdx, offsetBy: Int(point))
        
        let beforeStrings = floatValueString[startIdx..<midIdx]
        let midString = floatValueString[midIdx].description
        
        // flag = true 表示进1，否则表示舍弃
        var flag = true
        
        let five = "5"
        // 小数点后面的数字
        if midString < five { // 四舍
            flag = false
        } else if midString > five { // 六入
            flag = true
        } else {    // 五考虑
            if Double(floatValueString)! == Double(beforeStrings + midString)!  { // 五后皆零看奇偶
                let beforeMidString = floatValueString[floatValueString.index(before: midIdx)].description
                // 五前偶舍奇进一
                flag = Int(beforeMidString)! % 2 != 0
            } else {    // 五后非零则进一
                flag = true
            }
        }
        
        let pointString = (Int(beforeStrings)! + (flag ? 1 : 0)).description
        return Double(intValueString + "." + pointString)!
    }
    
    static func zz_46Value(value: Double, point: UInt) -> Double {
        return value.zz_46Value(point: point)
    }
    
}
