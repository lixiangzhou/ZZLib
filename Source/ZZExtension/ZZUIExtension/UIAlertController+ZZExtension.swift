//
//  UIAlertController+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/3/10.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

public extension UIAlertController {
    /// 快捷弹窗，Alert 样式或者 ActionSheet样式
    ///
    /// - parameter fromController: 弹窗所在的控制器
    /// - parameter style:          弹窗样式，UIAlertControllerStyle.alert 或者 UIAlertControllerStyle.actionSheet
    /// - parameter title:          title
    /// - parameter message:        message
    /// - parameter actions:        actions
    /// - parameter completion:     弹窗消失执行的操作
    ///
    /// - returns: 弹窗对象 UIAlertController
    @discardableResult
    static func zz_show(fromController: UIViewController,
                        style: UIAlertControllerStyle = .alert,
                        title: String? = nil,
                        message: String? = nil,
                        actions: [UIAlertAction],
                        completion: (() -> Void)? = nil) -> UIAlertController {
        
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            alertVc.addAction(action)
        }
        
        fromController.present(alertVc, animated: true, completion: completion)
        return alertVc
    }
}
