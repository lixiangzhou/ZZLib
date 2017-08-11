//
//  Data+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/3/22.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import Foundation

public extension Data {
    /// data 的utf8字符串
    var zz_utf8String: String? {
        return String(data: self, encoding: .utf8)
    }
}


// MARK: - UIImage Data Format
public extension Data {
    private struct UIImageHeaderData {
        static var PNG: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
        static var JPEG_SOI: [UInt8] = [0xFF, 0xD8]
        static var JPEG_IF: [UInt8] = [0xFF]
        static var GIF: [UInt8] = [0x47, 0x49, 0x46]
    }
    
    enum UIImageFormat {
        case unknown, PNG, JPEG, GIF
    }
    
    var zz_imageFormat: UIImageFormat {
        var buffer = [UInt8](repeating:0, count: 8)
        (self as NSData).getBytes(&buffer, length: 8)
        
        if buffer == UIImageHeaderData.PNG {
            return .PNG
        } else if buffer[0] == UIImageHeaderData.JPEG_SOI[0] &&
            buffer[1] == UIImageHeaderData.JPEG_SOI[1] &&
            buffer[2] == UIImageHeaderData.JPEG_IF[0] {
            return .JPEG
        } else if buffer[0] == UIImageHeaderData.GIF[0] &&
            buffer[1] == UIImageHeaderData.GIF[1] &&
            buffer[2] == UIImageHeaderData.GIF[2] {
            return .GIF
        } else {
            return .unknown
        }
    }
}
