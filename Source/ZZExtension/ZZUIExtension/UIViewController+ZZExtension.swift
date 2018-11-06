//
//  UIViewController+ZZExtension.swift
//  ZZHxb
//
//  Created by lxz on 2018/3/27.
//  Copyright © 2018年 lixiangzhou. All rights reserved.
//

import UIKit

public extension UIViewController {
    func popToViewController(_ viewControllerName: String, animated: Bool = true) {
        guard let childVC = navigationController?.childViewControllers else {
            return
        }
        
        var targetVC: UIViewController?
        let vcName = (Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? "") + ".\(viewControllerName)"
        for vc in childVC {
            if vc.classForCoder.description() == vcName {
                targetVC = vc
                break
            }
        }
        
        if targetVC != nil {
            navigationController?.popToViewController(targetVC!, animated: animated)
        }
    }
}
