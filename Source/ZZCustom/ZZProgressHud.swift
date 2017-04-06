//
//  ZZProgressHud.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/5.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

private var huds = [Int: ZZProgressHud]()

struct ZZProgressHud {
    
    private init() { }
    
    // MARK - 私有属性
    private let bgView = UIView()
    private lazy var contentView = UIView()
    
    // MARK - 最基本的访问方法，根据需求设置自己需要的样式
    
    /// 显示 hud， 最基本的 hud 自定义方法
    ///
    /// - parameter view:                  hud 将要添加到的 view, 默认是 keyWindow
    /// - parameter animated:              是否执行动画
    /// - parameter identifier:            hud 的ID，必须要设置
    /// - parameter bgColor:               hud 的背景色
    /// - parameter offsetCenterY:         hud 主要内容的 y 轴偏移量
    /// - parameter hud:                   自定义的 hud，如果设置了 hud，下面的属性无效
    /// - parameter image:                 基本 hud 的图片
    /// - parameter imageSize:             基本 hud 的图片大小
    /// - parameter imageCornerRadius:     基本 hud 的图片圆角
    /// - parameter text:                  基本 hud 的文本
    /// - parameter textLineNum:           基本 hud 的文本最大行数
    /// - parameter textFontSize:          基本 hud 的文本字体大小
    /// - parameter textColor:             基本 hud 的文本字体颜色
    /// - parameter textMaxWidth:          基本 hud 的文本最大宽度
    /// - parameter margin:                基本 hud 的文本 和 基本 hud 的图片的间距
    /// - parameter edgeInset:             基本 hud 的文本 和 基本 hud 的图片 所包裹的 view 的间距
    /// - parameter contentBgColor:        基本 hud 的文本 和 基本 hud 的图片 所包裹的 view 的背景色
    /// - parameter contentBgCornerRadius: 基本 hud 的文本 和 基本 hud 的图片 所包裹的 view 的圆角
    ///
    /// - returns: 返回一个自定义的 hud, 如果 hud, image, text 都没有提供，将返回一个无效的 hud
    @discardableResult
    static func showHud(from view: UIView = UIApplication.shared.keyWindow!, animated: Bool = true,
                        identifier: Int, bgColor: UIColor? = nil, offsetCenterY: CGFloat = 0,
                        hud: UIView? = nil,
                        image: UIImage? = nil, imageSize: CGSize = CGSize.zero, imageCornerRadius: CGFloat = 0,
                        text: String? = nil, textLineNum: Int = 1, textFontSize: CGFloat = 14, textColor: UIColor = .darkGray, textMaxWidth: CGFloat = 0,
                        margin: CGFloat = 10, edgeInset: UIEdgeInsets = .zero, contentBgColor: UIColor = UIColor.white, contentBgCornerRadius: CGFloat = 0) -> ZZProgressHud {
        
        var progressHud = ZZProgressHud()
        let bgView = progressHud.bgView
        
        bgView.frame = view.bounds
        bgView.backgroundColor = bgColor
        
        if let hud = hud {  // 自定义的 hud
            bgView.addSubview(hud)
            hud.center = bgView.center
            hud.center.y += offsetCenterY
        } else {    // 设置 hud 的各种参数
            progressHud.contentView.backgroundColor = contentBgColor
            bgView.addSubview(progressHud.contentView)
            
            if contentBgCornerRadius > 0 {
                progressHud.contentView.layer.cornerRadius = contentBgCornerRadius
                progressHud.contentView.layer.masksToBounds = true
            }
            
            var imgView: UIImageView!
            if let image = image {  // 图片
                imgView = UIImageView(image: image)
                if imageSize != .zero {
                    imgView.frame.size = imageSize
                }
                if imageCornerRadius > 0 {
                    imgView.layer.cornerRadius = imageCornerRadius
                    imgView.layer.masksToBounds = true
                }
                progressHud.contentView.addSubview(imgView)
            }
            
            var textLabel: UILabel!
            if let text = text {    // 文字
                textLabel = UILabel(text: text, fontSize: textFontSize, textColor: textColor, numOfLines: textLineNum, textAlignment: .center)
                textLabel.sizeToFit()
                if textMaxWidth > 0 {
                    textLabel.zz_size = text.zz_size(withLimitSize: CGSize(width: textMaxWidth, height: zz_Font(fontSize: textFontSize).lineHeight * CGFloat(textLineNum)), fontSize: textFontSize)
                }
                progressHud.contentView.addSubview(textLabel)
            }
            
            let edgeX = edgeInset.left + edgeInset.right
            let edgeY = edgeInset.top + edgeInset.bottom
            
            if image != nil, text == nil {  // 只有图片
                progressHud.contentView.zz_size = CGSize(width: imgView.zz_width + edgeX,
                                                         height: imgView.zz_height + edgeY)
                imgView.zz_x = edgeInset.left
                imgView.zz_y = edgeInset.top
            }
            else if image == nil, text != nil {   // 只有文字
                progressHud.contentView.zz_size = CGSize(width: textLabel.zz_width + edgeX,
                                                         height: textLabel.zz_height + edgeY)
                textLabel.zz_x = edgeInset.left
                textLabel.zz_y = edgeInset.top
            }
            else if image != nil, text != nil {   // 有文字和图片
                let width = max(imgView.zz_width, textLabel.zz_width)
                let height = imgView.zz_height + textLabel.zz_height + margin
                progressHud.contentView.zz_size = CGSize(width: width + edgeX, height: height + edgeY)
                
                if width == imgView.zz_width {  // 图片更宽
                    imgView.zz_x = edgeInset.left
                    imgView.zz_y = edgeInset.bottom
                    
                    textLabel.center.x = imgView.center.x
                    textLabel.zz_y = imgView.frame.maxY + margin
                } else {    // 文字更宽
                    textLabel.zz_x = edgeInset.left
                    textLabel.zz_maxY = progressHud.contentView.zz_size.height - edgeInset.bottom
                    
                    imgView.center.x = textLabel.center.x
                    imgView.zz_y = edgeInset.top
                }
            }
            else {    // 什么都没有，什么都不做
                progressHud.contentView.center = bgView.center
                return progressHud
            }
            
            progressHud.contentView.center = bgView.center
            if offsetCenterY != 0 {
                progressHud.contentView.center.y += offsetCenterY
            }
        }
        
        view.addSubview(progressHud.bgView)
        huds[identifier] = progressHud
        
        if animated {
            bgView.alpha = 0
            UIView.animate(withDuration: 0.25, animations: { 
                bgView.alpha = 1
            })
        }
        
        return progressHud
    }
    
    /// 隐藏 hud
    ///
    /// - parameter animated:   是否执行动画
    /// - parameter identifier: hud 的ID，必须要设置
    static func hide(animated: Bool, identifier: Int) {
        if let hud = huds[identifier] {
            hud.bgView.alpha = 1
            huds[identifier] = nil
            UIView.animate(withDuration: 0.25, animations: { 
                hud.bgView.alpha = 0
                }, completion: { (_) in
                    hud.bgView.removeFromSuperview()
            })
        }
    }
}

/// 自定义案例
extension ZZProgressHud {
    static func show(text: String, duration: TimeInterval = 2) {
        let id = Int(arc4random())
        showHud(identifier: id, text: text, textLineNum: 2, textFontSize: 16, textColor: UIColor.white, textMaxWidth: 160, edgeInset: UIEdgeInsetsMake(12, 12, 12, 12), contentBgColor: UIColor(white: 0, alpha: 0.8))
        DispatchQueue.main.zz_after(duration) {
            hide(animated: true, identifier: id)
        }
    }
    
    static func show(image: UIImage, duration: TimeInterval = 2) {
        let id = Int(arc4random())
        showHud(identifier: id, image: image)
        DispatchQueue.main.zz_after(duration) {
            hide(animated: true, identifier: id)
        }
    }
    
    static func showProgressing(duration: TimeInterval = Double(MAXFLOAT)) {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.startAnimating()
        
        let id = Int(arc4random())
        showHud(identifier: id, hud: indicator)
        DispatchQueue.main.zz_after(duration) {
            hide(animated: true, identifier: id)
        }
    }
}
