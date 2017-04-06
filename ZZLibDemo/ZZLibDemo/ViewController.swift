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
        
        let progressView = view.zz_add(subview: ZZCircleProgressView(frame: view.bounds)) as! ZZCircleProgressView
        progressView.progress = 0.75;
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     
        
        
    }
}

