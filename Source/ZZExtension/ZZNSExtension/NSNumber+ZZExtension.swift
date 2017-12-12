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
    
    
    /// 放回整数的长度，不包括正负符号
    var length: Int {
        return "\(self)".count - (self < 0 ? 1 : 0)
    }
}
