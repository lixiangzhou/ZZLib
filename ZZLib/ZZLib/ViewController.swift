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
        
//        print("hello".zz_substring(range: NSRange(location: 3, length: 2)))
        let num = 12345
        print(num[4] ?? 1_000_000_000)
        print(num.length)
    }

}


