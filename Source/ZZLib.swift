//
//  ZZLib.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/2.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import Foundation


/// 打印消息
///
/// - Parameters:
///   - msg: 消息内容
///   - file: 文件
///   - line: 行数
///   - method: 方法名
public func zz_print<T>(_ msg: T, file: String = #file, line: Int = #line, method: String = #function) {
    print("\((file as NSString).lastPathComponent) \(method):\(line) \(msg)")
}


/// 锁住一个对象，避免并发问题
///
/// - Parameters:
///   - lock: 要锁住的对象
///   - closure: 锁住对象后执行的方法
public func zz_synchronized(lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
