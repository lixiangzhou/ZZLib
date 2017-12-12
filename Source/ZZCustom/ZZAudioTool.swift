//
//  ZZAudioTool.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/10/6.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import Foundation
import AVFoundation

/// 简单的音效播放工具
class ZZAudioTool {
    static let shared = ZZAudioTool()
    
    private init() {}
    
    private var soundCaches = [URL: SystemSoundID]()
    
    private enum ZZPlaySoundType {
        case system     // 不带震动音效
        case alert      // 带震动音效
    }
    
    /// 播放带震动的音效
    ///
    /// - Parameters:
    ///   - url: 音效文件的url
    ///   - completionBlock: 播放完音效的回调
    func playAlertSound(url: URL, completionBlock: ((SystemSoundID?) -> Void)?) {
        playSound(url: url, type: .alert, completionBlock: completionBlock)
    }
    
    /// 播放不带震动的音效
    ///
    /// - Parameters:
    ///   - url: 音效文件的url
    ///   - completionBlock: 播放完音效的回调
    func playSystemSound(url: URL, completionBlock: ((SystemSoundID?) -> Void)?) {
        playSound(url: url, type: .system, completionBlock: completionBlock)
    }
    
    /// 清空音效缓存
    func clearCache() {
        soundCaches.forEach { (each) in
            AudioServicesDisposeSystemSoundID(each.1)
        }
    }
    
    /// 播放音效
    ///
    /// - Parameters:
    ///   - url: 音效文件的url
    ///   - type: 音效的类型
    ///   - completionBlock: 播放完音效的回调
    private func playSound(url: URL, type: ZZPlaySoundType, completionBlock: ((SystemSoundID?) -> Void)?) {
        
        // 先从缓存中获取音效文件
        var soundId = soundCaches[url] ?? 0
        
        if soundId == 0 {  // 缓存中没有，就创建
            AudioServicesCreateSystemSoundID(url as CFURL, &soundId) // 如果成功创建音效，soundId != 0，相当于指向音效文件的地址
            if soundId == 0 {   // 如果创建失败，直接返回
                completionBlock?(nil);
                return
            }
            soundCaches[url] = soundId
        }
        
        switch type {
            
        case .alert: AudioServicesPlayAlertSoundWithCompletion(soundId) {
            completionBlock?(soundId)
            }
        case .system: AudioServicesPlaySystemSoundWithCompletion(soundId) {
            completionBlock?(soundId)
            }
        }
    }
}
