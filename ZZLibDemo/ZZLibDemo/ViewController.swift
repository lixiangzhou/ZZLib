//
//  ViewController.swift
//  ZZLibDemo
//
//  Created by lixiangzhou on 2017/3/23.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    var tiped = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
//            ZZProgressHud.showHud(from: view, animated: true, identifier: 1, bgColor: nil, offsetCenterY: 0, hud: nil, image: nil, imageSize: CGSize(width: 30, height: 30), imageCornerRadius: 20, text: "loading...loading...loading...loading...loading...loading...", textLineNum: 3, textFontSize: 14, textColor: UIColor.red, textMaxWidth: 150, margin: 30, edgeInset: UIEdgeInsetsMake(0, 0, 0, 0), contentBgColor: UIColor.lightGray, contentBgCornerRadius: 10)
            
//            ZZProgressHud.show(text: "Tomorrow is better")
            
//            ZZProgressHud.show(image: UIImage(named: "ok")!)
        
        ZZProgressHud.showProgressing(duration: 3)
    }


}

