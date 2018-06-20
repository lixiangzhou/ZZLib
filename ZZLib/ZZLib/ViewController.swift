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

        let field = ZZNumberTextField(frame: CGRect(x: 20, y: 60, width: 300, height: 30))
        field.borderStyle = .roundedRect
        field.lengthLimit = 18
        field.additionIncludeCharacterSet = CharacterSet(charactersIn: "Xx")
        field.sepMode = [6, 8, 4]
        view.addSubview(field)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
