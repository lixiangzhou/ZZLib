//
//  ViewController.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/2.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

class TestCell: ZZCycleViewCell {
    static let identifier = "TestCellID"
    
    let textLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.frame = bounds
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 80)
        
        contentView.addSubview(textLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    
    var cycleView: ZZCycleView!
    override func viewDidLoad() {
        super.viewDidLoad()

        cycleView = ZZCycleView(frame: CGRect(x: 0, y: 100, width: view.frame.width, height: 300))
        cycleView.cycleCount = 3
        cycleView.clockwise = false
        cycleView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.identifier)
        cycleView.cellForIndex = { cycleView, index in
            let cell = cycleView.dequeueReusableCell(withReuseIdentifier: TestCell.identifier, for: index) as! TestCell
            cell.backgroundColor = UIColor.orange
            cell.textLabel.text = "\(index)"
            return cell
        }
        view.addSubview(cycleView)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cycleView.bounds.size
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        
        cycleView.layout = layout
    }
}
