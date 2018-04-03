//
//  String+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/3/10.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit


// MARK: - Other
public extension String {
    /// 去掉空白字符串
    var zz_trim: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 转成NSString
    var zz_ns: NSString {
        return self as NSString
    }
    
    /// emoji表情
    var zz_emoji: String? {
        let scanner = Scanner(string: self)
        var value: UInt32 = 0
        scanner.scanHexInt32(&value)
        guard let scalar = UnicodeScalar(value) else {
            return nil
        }
        return Character(scalar).description
    }
}


// MARK: - Date
public extension String {
    
    /// 根据格式获取字符串的Date对象
    ///
    /// 常用格式：
    /// G:          公元时代，例如AD公元
    ///
    /// yy:         年的后2位
    ///
    /// yyyy:       完整年
    ///
    /// MM:         月，显示为1-12,带前置0
    ///
    /// MMM:        月，显示为英文月份简写,如 Jan
    ///
    /// MMMM:       月，显示为英文月份全称，如 Janualy
    ///
    /// dd:         日，2位数表示，如02
    ///
    /// d:          日，1-2位显示，如2，无前置0
    ///
    /// EEE:        简写星期几，如Sun
    ///
    /// EEEE:       全写星期几，如Sunday
    ///
    /// aa:         上下午，AM/PM
    ///
    /// H:          时，24小时制，0-23
    ///
    /// HH:         时，24小时制，带前置0
    ///
    /// h:          时，12小时制，无前置0
    ///
    /// hh:         时，12小时制，带前置0
    ///
    /// m:          分，1-2位
    ///
    /// mm:         分，2位，带前置0
    ///
    /// s:          秒，1-2位
    ///
    /// ss:         秒，2位，带前置0
    ///
    /// S:          毫秒
    ///
    /// Z：          GMT（时区）
    /// - parameter format: 时间格式
    ///
    /// - returns: 指定格式的时间对象
    func zz_date(withDateFormat format: String) -> Date? {
        zz_dateFormatter.dateFormat = format
        return zz_dateFormatter.date(from: self)
    }
}


// MARK: - 子字符串
public extension String {
    
    /// 获取字符串的size
    ///
    /// - parameter size:       限制大小
    /// - parameter fontSize:   字体大小
    ///
    /// - returns: 字符串的size
    func zz_size(withLimitSize size: CGSize, fontSize: CGFloat) -> CGSize {
        let size = (self as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    /// 获取字符串的size
    ///
    /// - parameter size:       限制大小
    /// - parameter fontSize:   字体大小
    ///
    /// - returns: 字符串的size
    func zz_size(withLimitWidth width: CGFloat, fontSize: CGFloat) -> CGSize {
        return zz_size(withLimitSize: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), fontSize: fontSize)
    }
    
    /// 获取字符串的size
    ///
    /// - parameter size:       限制大小
    /// - parameter fontSize:   字体大小
    ///
    /// - returns: 字符串的size
    func zz_size(withLimitHeight height: CGFloat, fontSize: CGFloat) -> CGSize {
        return zz_size(withLimitSize: CGSize(width: CGFloat.leastNormalMagnitude, height: height), fontSize: fontSize)
    }
    
    /// 获取子字符串
    ///
    /// - parameter range:       范围
    ///
    /// - returns: 子字符串
    func zz_substring(range: NSRange) -> String {
        let startIdx = index(startIndex, offsetBy: range.location)
        let endIdx = index(startIdx, offsetBy: range.length)
        
        return String(self[startIdx..<endIdx])
//        return substring(with: startIdx..<endIdx)
    }
    
    /// 替换字符串
    ///
    /// - Parameters:
    ///   - start: 开始替换位置
    ///   - length: 替换字符串的长度
    ///   - with: 要替换的字符串
    /// - Returns: 替换后的字符串
    func zz_replace(start: Int, length: Int, with: String) -> String {
        // 越界判断
        if start + length > count || start < 0 {
            return self
        }
        
        var result = ""
        // 替换字符串之前的部分，如果有就拼接上
        if start > 0 {
            result.append(String(self[startIndex..<index(startIndex, offsetBy: start)]))
        }
        
        // 替换字符串
        for _ in 0..<length {
            result.append(with)
        }
        
        // 最后剩余的部分，如果有就拼接上
        let left = count - (start + length)
        if left > 0 {
            result.append(String(self[index(endIndex, offsetBy: -left)..<endIndex]))
        }
        return result
    }
}


