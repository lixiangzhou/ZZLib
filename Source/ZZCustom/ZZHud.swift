//
//  ZZHud.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/9/5.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

/// Hud显示位置
///
/// - top: 最顶部
/// - center: 中间
/// - bottom: 最底部
enum ZZHudPosition {
    case top
    case center
    case bottom
}

class ZZView: UIView { }

/// Toast & ProgressHud
struct ZZHud {
    static let shared = ZZHud()
    
    private init() { }
    
    /// 默认的显示动画
    var defaultShowAnimation: CAAnimation = {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.duration = 0.25
        anim.fromValue = 0
        anim.toValue = 1
        return anim
    }()
    
    /// 默认的隐藏动画
    var defaultHideAnimation: CAAnimation = {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.duration = 0.25
        anim.fromValue = 1
        anim.toValue = 0
        return anim
    }()
    
}

// MARK: - Commmon
extension ZZHud {
    
}

// MARK: - Core Method
extension ZZHud {
    
    /// 显示toast
    ///
    /// - Parameters:
    ///   - hud: toast视图
    ///   - toView: toast视图所在的View
    ///   - toViewCornerRadius: toast视图所在的View的cornerRadius
    ///   - toViewBackground: toast视图所在的View的backgroundColor
    ///   - toViewAlpha: toast视图所在的View的alpha
    ///   - contentInset: toast视图所在的View的contentInset
    ///   - position: toast视图显示的位置
    ///   - offsetY: toast视图显示的位置的垂直偏移量
    ///   - showDuration: toast视图显示时长
    ///   - showAnimation: toast视图显示动画
    ///   - hideAnimation: toast视图隐藏动画
    func show(toast hud: UIView,
              toView: UIView,
              toViewCornerRadius: CGFloat = 3,
              toViewBackgroundColor: UIColor = .black,
              toViewAlpha: CGFloat = 0.8,
              contentInset: UIEdgeInsets = .zero,
              position: ZZHudPosition = .center,
              offsetY: CGFloat = 0,
              showDuration: TimeInterval = 2,
              showAnimation: (() -> CAAnimation)? = nil,
              hideAnimation: (() -> CAAnimation)? = nil) {
        
        let hudView = wrap(hud,
                           cornerRadius: toViewCornerRadius,
                           backgroundColor: toViewBackgroundColor,
                           alpha: toViewAlpha,
                           contentInset: contentInset)
        
        add(hud: hudView, toView: toView, position: position, offsetY: offsetY)
        
        let showAnim = showAnimation != nil ? showAnimation!() : defaultShowAnimation
        let hideAnim = hideAnimation != nil ? hideAnimation!() : defaultHideAnimation
        toast(hud: hudView, showDuration: showDuration, showAnimation: showAnim, hideAnimation: hideAnim)
    }
    
    /// 显示progress
    ///
    /// - Parameters:
    ///   - hud: progress视图
    ///   - toView: progress视图所在的View
    ///   - toViewCornerRadius: progress视图所在的View的cornerRadius
    ///   - toViewBackground: progress视图所在的View的backgroundColor
    ///   - toViewAlpha: progress视图所在的View的alpha
    ///   - contentInset: toast视图所在的View的contentInset
    ///   - position: progress视图显示的位置
    ///   - offsetY: progress视图显示的位置的垂直偏移量
    ///   - showDuration: progress视图显示时长
    ///   - animation: progress视图显示的动画
    /// - Returns: progress视图
    @discardableResult
    func show(progress hud: UIView,
              toView: UIView,
              toViewCornerRadius: CGFloat = 3,
              toViewBackgroundColor: UIColor = .black,
              toViewAlpha: CGFloat = 0.8,
              contentInset: UIEdgeInsets = .zero,
              position: ZZHudPosition = .center,
              offsetY: CGFloat = 0,
              showDuration: TimeInterval = 2,
              animation: (() -> CAAnimation)? = nil) -> UIView {
        
        let hudView = wrap(hud,
                           cornerRadius: toViewCornerRadius,
                           backgroundColor: toViewBackgroundColor,
                           alpha: toViewAlpha,
                           contentInset: contentInset)
        
        add(hud: hudView, toView: toView, position: position, offsetY: offsetY)
        
        let showAnim = animation != nil ? animation!() : defaultShowAnimation
        showProgress(hud: hudView, showAnimation: showAnim)
        
        return hudView
    }
    
    /// 取消view的所有progress
    ///
    /// - Parameters:
    ///   - view: progress视图所在的View
    ///   - animation: progress视图显示的动画
    func hideProgress(for view: UIView,
                      animation: (() -> CAAnimation)? = nil) {
        for subView in view.subviews {
            if subView is ZZView {
                subView.hideProgress(animation: animation)
            }
        }
    }
}


// MARK: - Helper
extension ZZHud {
    
    /// 显示toast
    ///
    /// - Parameters:
    ///   - hud: toast视图
    ///   - showDuration:  toast视图显示时长
    ///   - showAnimation: toast视图显示动画
    ///   - hideAnimation: toast视图隐藏动画
    fileprivate func toast(hud: UIView,
                           showDuration: TimeInterval,
                           showAnimation: CAAnimation,
                           hideAnimation: CAAnimation) {
        var duration = max(0, showDuration)
        
        duration = duration + showAnimation.duration
        hud.layer.add(showAnimation, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
            hud.layer.add(hideAnimation, forKey: nil)
            hud.perform(#selector(UIView.removeFromSuperview), with: nil, afterDelay: hideAnimation.duration, inModes: [.commonModes])
        })
    }
    
    /// 显示progress
    ///
    /// - Parameters:
    ///   - hud: progress视图
    ///   - showAnimation: toast视图显示动画
    fileprivate func showProgress(hud: UIView,
                                  showAnimation: CAAnimation) {
        hud.layer.add(showAnimation, forKey: nil)
    }
    
    /// 把hud添加到视图上
    ///
    /// - Parameters:
    ///   - hud: hud
    ///   - toView: hud将添加到的视图
    ///   - position: hud在toView的位置
    ///   - offsetY: hud在toView位置的偏移量
    fileprivate func add(hud: UIView,
                         toView: UIView,
                         position: ZZHudPosition,
                         offsetY: CGFloat) {
        var hudFrame = hud.frame
        let toViewFrame = toView.bounds
        
        let hudX = (toViewFrame.width - hudFrame.width) * 0.5
        
        switch position {
        case .center:
            hudFrame.origin = CGPoint(x: hudX, y: (toViewFrame.height - hudFrame.height) * 0.5)
        case .top:
            hudFrame.origin = CGPoint(x: hudX, y: 0)
        case .bottom:
            hudFrame.origin = CGPoint(x: hudX, y: toViewFrame.height - hudFrame.height)
        }
        
        hudFrame.origin.y += offsetY
        hud.frame = hudFrame
        toView.addSubview(hud)
    }
    
    /// 把hud包装成ZZView
    ///
    /// - Parameter hud: 要包装的hud
    /// - Parameter cornerRadius: 包装好的hud的cornerRadius
    /// - Parameter backgroundColor: 包装好的hud的backgroundColor
    /// - Parameter alpha: 包装好的hud的alpha
    /// - Parameter contentInset: 要包装的hud的contentInset
    /// - Returns: 包装好的hud
    fileprivate func wrap(_ hud: UIView,
                          cornerRadius: CGFloat,
                          backgroundColor: UIColor,
                          alpha: CGFloat,
                          contentInset: UIEdgeInsets) -> ZZView {
        let hudView = ZZView(frame: CGRect(x: 0,
                                           y: 0,
                                           width: contentInset.left + contentInset.right + hud.bounds.width,
                                           height: contentInset.top + contentInset.bottom + hud.bounds.height))
        
        hud.frame.origin.x = contentInset.left
        hud.frame.origin.y = contentInset.top
        
        hud.layer.cornerRadius = min(hudView.bounds.width * 0.5, cornerRadius)
        hud.layer.backgroundColor = backgroundColor.cgColor
        hud.alpha = alpha
        
        hudView.addSubview(hud)
        return hudView
    }
}

// MARK: - ZZHud
extension UIView {
    
    /// 隐藏
    ///
    /// - Parameter animation: 隐藏progress动画
    func hideProgress(animation: (() -> CAAnimation)? = nil) {
        let hideAnimation = animation != nil ? animation!() : ZZHud.shared.defaultHideAnimation
        DispatchQueue.main.asyncAfter(deadline: .now() + hideAnimation.duration, execute: {
            self.layer.add(hideAnimation, forKey: nil)
            self.perform(#selector(UIView.removeFromSuperview), with: nil, afterDelay: hideAnimation.duration, inModes: [.commonModes])
        })
        
    }
}


