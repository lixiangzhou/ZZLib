//
//  ZZHud.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/9/5.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

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
    
    /// 显示文本信息
    ///
    /// - Parameters:
    ///   - message: 文本信息
    ///   - font: 文本字体
    ///   - color: 文本颜色
    ///   - toView: 文本信息要显示到的View
    static func show(message: String,
              font: UIFont = UIFont.systemFont(ofSize: 14),
              color: UIColor = UIColor.white,
              toView: UIView) {
        ZZHud.shared.show(message: message, font: font, color: color, toView: toView)
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
              cornerRadius: CGFloat = 0,
              toView: UIView) {
        let iconView = hudImageView(icon: icon, size: size, cornerRadius: cornerRadius)
        show(toast: iconView, toView: toView, toViewCornerRadius: 5, toViewBackgroundColor: UIColor.white, toViewAlpha: 1)
    }

    /// 显示图片
    ///
    /// - Parameters:
    ///   - icon: 图片
    ///   - size: 图片大小
    ///   - cornerRadius: 图片圆角
    ///   - toView: 图片要添加到的View
    static func show(icon: UIImage,
              size: CGSize = CGSize.zero,
              cornerRadius: CGFloat = 0,
              toView: UIView) {
        ZZHud.shared.show(icon: icon, size: size, cornerRadius: cornerRadius, toView: toView)
    }
    
    /// 显示图片和文本，图片在上，文本在下
    ///
    /// - Parameters:
    ///   - message: 文本信息
    ///   - font: 文本字体
    ///   - color: 文本颜色
    ///   - icon: 图片
    ///   - size: 图片大小
    ///   - cornerRadius: 图片圆角
    ///   - padding: 图片和文本的间距
    ///   - toView: 图片要添加到的View
    func show(message: String,
              font: UIFont = UIFont.systemFont(ofSize: 14),
              color: UIColor = UIColor.black,
              icon: UIImage,
              size: CGSize = CGSize.zero,
              cornerRadius: CGFloat = 0,
              padding: CGFloat = 10,
              toView: UIView) {
        let iconView = hudImageView(icon: icon, size: size, cornerRadius: cornerRadius)
        let msgLabel = hudLabel(message: message, font: font, color: color)
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: max(iconView.bounds.width, msgLabel.bounds.width), height: iconView.bounds.height + msgLabel.bounds.height + padding))
        contentView.addSubview(iconView)
        contentView.addSubview(msgLabel)
        
        iconView.frame.origin.x = (contentView.frame.width - iconView.frame.width) * 0.5
        
        msgLabel.frame.origin.x = (contentView.frame.width - msgLabel.frame.width) * 0.5
        msgLabel.frame.origin.y = iconView.frame.maxY + padding
        
        show(toast: contentView, toView: toView, toViewBackgroundColor: UIColor.white)
    }
    
    /// 显示图片和文本，图片在上，文本在下
    ///
    /// - Parameters:
    ///   - message: 文本信息
    ///   - font: 文本字体
    ///   - color: 文本颜色
    ///   - icon: 图片
    ///   - size: 图片大小
    ///   - cornerRadius: 图片圆角
    ///   - padding: 图片和文本的间距
    ///   - toView: 图片要添加到的View
    static func show(message: String,
              font: UIFont = UIFont.systemFont(ofSize: 14),
              color: UIColor = UIColor.black,
              icon: UIImage,
              size: CGSize = CGSize.zero,
              cornerRadius: CGFloat = 0,
              padding: CGFloat = 10,
              toView: UIView) {
        ZZHud.shared.show(message: message, font: font, color: color, icon: icon, size: size, cornerRadius: cornerRadius, padding: padding, toView: toView)
    }
    
    /// 显示UIActivityIndicatorViewStyle加载，，隐藏时调用 hideLoading 或 hideAllLoading
    ///
    /// - Parameters:
    ///   - style: UIActivityIndicatorViewStyle加载样式
    ///   - toView: 加载视图要添加到的View
    ///   - loadingId: 加载视图的id，方便在删除的时候定位要删除的loadingView
    @discardableResult
    func showActivity(style: UIActivityIndicatorViewStyle = .gray, toView: UIView, loadingId: Int = NSNotFound) -> ZZView {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: style)
        activityView.startAnimating()
        return show(loading: activityView, loadingId: loadingId, toView: toView, toViewBackgroundColor: UIColor.clear)
    }
    
    /// 显示UIActivityIndicatorViewStyle加载，隐藏时调用 hideLoading 或 hideAllLoading
    ///
    /// - Parameters:
    ///   - style: UIActivityIndicatorViewStyle加载样式
    ///   - toView: 加载视图要添加到的View
    ///   - loadingId: 加载视图的id，方便在删除的时候定位要删除的loadingView
    @discardableResult
    static func showActivity(style: UIActivityIndicatorViewStyle = .gray, toView: UIView, loadingId: Int = NSNotFound) -> ZZView {
        return ZZHud.shared.showActivity(style: style, toView: toView, loadingId: loadingId)
    }
}

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

/// Toast & LoadingHud
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
              toViewCornerRadius: CGFloat = 0,
              toViewBackgroundColor: UIColor = .black,
              toViewAlpha: CGFloat = 1,
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
    
    /// 显示loading
    ///
    /// - Parameters:
    ///   - hud: loading视图
    ///   - loadingId: loading视图的Id
    ///   - toView: loading视图所在的View
    ///   - toViewCornerRadius: loading视图所在的View的cornerRadius
    ///   - toViewBackground: loading视图所在的View的backgroundColor
    ///   - toViewAlpha: loading视图所在的View的alpha
    ///   - contentInset: toast视图所在的View的contentInset
    ///   - position: loading视图显示的位置
    ///   - offsetY: loading视图显示的位置的垂直偏移量
    ///   - animation: loading视图显示的动画
    /// - Returns: loading视图
    @discardableResult
    func show(loading hud: UIView,
              loadingId: Int,
              toView: UIView,
              toViewCornerRadius: CGFloat = 0,
              toViewBackgroundColor: UIColor = .black,
              toViewAlpha: CGFloat = 1,
              contentInset: UIEdgeInsets = .zero,
              position: ZZHudPosition = .center,
              offsetY: CGFloat = 0,
              animation: (() -> CAAnimation)? = nil) -> ZZView {
        
        let hudView = wrap(hud,
                           cornerRadius: toViewCornerRadius,
                           backgroundColor: toViewBackgroundColor,
                           alpha: toViewAlpha,
                           contentInset: contentInset)
        hudView.tag = loadingId
        
        add(hud: hudView, toView: toView, position: position, offsetY: offsetY)
        
        let showAnim = animation != nil ? animation!() : defaultShowAnimation
        showLoading(hud: hudView, showAnimation: showAnim)
        
        return hudView
    }
    
    /// 隐藏view的loading
    ///
    /// - Parameters:
    ///   - view: loading视图所在的View
    ///   - animation: loading视图显示的动画
    ///   - loadingId: loading视图的id
    func hideLoading(for view: UIView,
                      animation: (() -> CAAnimation)? = nil,
                      loadingId: Int = NSNotFound) {
        if loadingId == NSNotFound {    // 隐藏最先添加的 loadview
            for subView in view.subviews {
                if subView is ZZView {
                    subView.hideLoading(animation: animation)
                    break
                }
            }
        } else {    // 隐藏指定id的loadview
            for subView in view.subviews {
                if subView is ZZView && loadingId == subView.tag {
                    subView.hideLoading(animation: animation)
                    break
                }
            }
        }
    }
    
    /// 隐藏view的所有loading
    ///
    /// - Parameters:
    ///   - view: loading视图所在的View
    ///   - animation: loading视图显示的动画
    func hideAllLoading(for view: UIView,
                        animation: (() -> CAAnimation)? = nil,
                        loadingId: Int = NSNotFound) {
        for subView in view.subviews {
            if subView is ZZView {
                subView.hideLoading(animation: animation)
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
    
    /// 显示loading
    ///
    /// - Parameters:
    ///   - hud: loading视图
    ///   - showAnimation: toast视图显示动画
    fileprivate func showLoading(hud: UIView,
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
    
    /// 快速创建hud要用到的ImageView
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
    /// - Parameter animation: 隐藏loading动画，如果为nil，使用默认的隐藏动画
    func hideLoading(animation: (() -> CAAnimation)? = nil) {
        let hideAnimation = animation != nil ? animation!() : ZZHud.shared.defaultHideAnimation
        layer.add(hideAnimation, forKey: nil)
        perform(#selector(UIView.removeFromSuperview), with: nil, afterDelay: hideAnimation.duration, inModes: [.commonModes])
    }
}

