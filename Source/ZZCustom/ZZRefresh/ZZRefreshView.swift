//
//  ZZRefreshView.swift
//  ZZRefresh
//
//  Created by lixiangzhou on 16/10/26.
//  Copyright © 2016年 lixiangzhou. All rights reserved.
//

import UIKit

open class ZZRefreshView: UIView {
    // MARK: - 公共属性
    public var style = ZZRefreshViewPositionStyle.bottom
    
    public func update(progress: CGFloat) { print(progress) }
    
    public var originInset = UIEdgeInsets.zero
    
    /// 此变量值用在footerView 上
    public var loadNoMoreData = false
    
    open var state: ZZRefreshState = ZZRefreshState.normal {
        didSet {
            if loadNoMoreData {
                return
            }
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
    public func beginRefreshing() {
        state = .refreshing
    }
    
    public func endRefreshing() {
        state = .normal
    }
    
    // MARK: - 生命周期方法
    public init(target: AnyObject, action: Selector, style: ZZRefreshViewPositionStyle = .bottom) {
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        if newSuperview == nil || newSuperview is UIScrollView == false {
            return
        }
        
        let scrollView = newSuperview as! UIScrollView
        
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        
        originInset = scrollView.contentInset
    }
    
    deinit {
        (superview as? UIScrollView)?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    // 自定义刷新控件时重写此方法
    open func setupUI() {  }
    
    // MARK: - 辅助属性
    var scrollView: UIScrollView! {
        return superview as! UIScrollView
    }
    
    // MARK: - 私有属性
    private weak var target: AnyObject?
    private var action: Selector?
}
