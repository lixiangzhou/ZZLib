//
//  ZZCircleProgressView.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/6.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

class ZZCircleProgressView: UIView {
    
    var progressColor: UIColor = UIColor.blue
    var trackColor: UIColor = UIColor.red
    var progressWidth: CGFloat = 3
    var progress: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        // 画轨迹圆
        let radius = min(rect.width, rect.height) * 0.5 - progressWidth * 0.5
        var scope = CGRect(origin: .zero, size: CGSize(width: radius * 2, height: radius * 2))
        scope.zz_center = rect.zz_center
        let trackPath = UIBezierPath(ovalIn: scope)
        trackColor.setStroke()
        trackPath.lineWidth = progressWidth
        trackPath.stroke()
        
        // 画进度圆
        let start: CGFloat = CGFloat(-Double.pi * 0.5)
        let end = start + progress * CGFloat(Double.pi * 2)
        let progressPath = UIBezierPath(arcCenter: rect.zz_center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        progressColor.setStroke()
        progressPath.lineWidth = progressWidth
        progressPath.stroke()
    }
    
}
