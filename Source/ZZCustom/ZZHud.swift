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

let stringMaxWidth = UIScreen.main.bounds.width - 140

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

// MARK: - Custom
extension ZZHud {
    
    /// 显示文本信息
    ///
    /// - Parameters:
    ///   - message: 文本信息
    ///   - font: 文本字体
    ///   - color: 文本颜色
    ///   - toView: 文本信息要显示到的View
    func show(message: String,
              font: UIFont = UIFont.systemFont(ofSize: 14),
              color: UIColor = UIColor.white,
              toView: UIView) {
        let msgLabel = hudLabel(message: message, font: font, color: color)
        show(toast: msgLabel, toView: toView)
    }

    
    /// 显示图片
    ///
    /// - Parameters:
    ///   - icon: 图片
    ///   - size: 图片大小
    ///   - cornerRadius: 图片圆角
    ///   - toView: 图片要添加到的View
    func show(icon: UIImage,
              size: CGSize = CGSize.zero,
              cornerRadius: CGFloat,
              toView: UIView) {
        let iconView = hudImageView(icon: icon, size: size, cornerRadius: cornerRadius)
        show(toast: iconView, toView: toView, toViewCornerRadius: 5, toViewBackgroundColor: UIColor.white, toViewAlpha: 1)
    }
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
              contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
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
        
        hudView.layer.cornerRadius = min(hudView.bounds.width * 0.5, cornerRadius)
        hudView.backgroundColor = backgroundColor
        hudView.alpha = alpha
        
        hudView.addSubview(hud)
        return hudView
    }
    
    /// 快速创建hud要用到的Label
    ///
    /// - Parameters:
    ///   - message: 文本信息
    ///   - font: 文本字体
    ///   - color: 文本颜色
    /// - Returns: 创建好的Label
    fileprivate func hudLabel(message: String,
                              font: UIFont,
                              color: UIColor) -> UILabel {
        let hudLabel = UILabel()
        hudLabel.font = font
        hudLabel.textColor = color
        hudLabel.text = message
        hudLabel.numberOfLines = 0
        hudLabel.frame = (message as NSString).boundingRect(with: CGSize(width: stringMaxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return hudLabel
    }
    
    /// 快速穿件hud要用到的ImageView
    ///
    /// - Parameters:
    ///   - icon: 图片
    ///   - size: 图片大小
    ///   - cornerRadius: 图片圆角
    /// - Returns: 创建好的ImageView
    fileprivate func hudImageView(icon: UIImage,
                                  size: CGSize,
                                  cornerRadius: CGFloat) -> UIImageView {
        let hudImageView = UIImageView()
        if size == .zero {
            hudImageView.frame.size = icon.size
        } else {
            hudImageView.frame.size = size
        }
        
        hudImageView.image = icon
        
        let r = min(size.width, size.height) * 0.5
        var radius = max(0, cornerRadius)
        radius = min(r, radius)
        hudImageView.layer.cornerRadius = radius
        return hudImageView
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

