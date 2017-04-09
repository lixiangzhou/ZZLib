//
//  ZZRefreshView.swift
//  ZZRefresh
//
//  Created by lixiangzhou on 16/10/26.
//  Copyright © 2016年 lixiangzhou. All rights reserved.
//

import UIKit

class ZZRefreshView: UIView {
    // MARK: - 公共属性
    var style = ZZRefreshViewPositionStyle.bottom
    
    func update(progress: CGFloat) { print(progress) }
    
    var originInset = UIEdgeInsets.zero
    
    var state: ZZRefreshState = ZZRefreshState.normal {
        didSet {
            if state == oldValue {
                return
            }
            
            switch state {
            case .normal:
                UIView.animate(withDuration: zz_RefreshConstant.headerRefreshDuration, animations: {
                    self.scrollView.contentInset = self.originInset
                })
            case .willRefreshing:
                break
            case .refreshing:
                if let target = target, let action = action {
                    _ = target.perform(action)
                }
            case .releaseRefreshing:
                break
            }
        }
    }
    
    // MARK: - 公共方法
    func beginRefreshing() {
        state = .refreshing
    }
    
    func endRefreshing() {
        state = .normal
    }
    
    // MARK: - 生命周期方法
    init(target: AnyObject, action: Selector, style: ZZRefreshViewPositionStyle = .bottom) {
        super.init(frame: CGRect.zero)
        self.target = target
        self.action = action
        self.style = style
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil || newSuperview is UIScrollView == false {
            return
        }
        
        let scrollView = newSuperview as! UIScrollView
        
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        originInset = scrollView.contentInset
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentOffset")
    }
    
    // 自定义刷新控件时重写此方法
    func setupUI() { backgroundColor = .red }
    
    // MARK: - 辅助属性
    var scrollView: UIScrollView! {
        return superview as! UIScrollView
    }
    
    // MARK: - 私有属性
    private var target: AnyObject?
    private var action: Selector?
}
