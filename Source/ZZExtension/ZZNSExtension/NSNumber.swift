//
//  NSNumber.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/8/4.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import Foundation

extension NSNumber {
    /// 是否Bool值
    var zz_isBool: Bool {
        return CFBooleanGetTypeID() == CFGetTypeID(self)
    }
}
