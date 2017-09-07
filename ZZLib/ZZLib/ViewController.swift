//
//  ViewController.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/2.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    var i = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.backgroundColor = UIColor.red
        
//        ZZHud.shared.show(message: "测试测试测试测试测试测试测试测试", toView: view)
//        ZZHud.shared.show(icon: UIImage(named: "icon")!, cornerRadius: 0, toView: view)
//        ZZHud.shared.show(message: "测试测试测试测试测试测试测试测试", icon: UIImage(named: "icon")!, cornerRadius: 0, toView: view)
        
        if i % 2 == 0 {
//            ZZHud.shared.show(loading: v, toView: view, position: .top, offsetY: 100)
            ZZHud.shared.showActivity(toView: view)
        } else {
            ZZHud.shared.hideLoading(for: view)
        }
        i = i + 1
        
//        ZZHud.shared.show(toast: v, toView: view)
    }
}


