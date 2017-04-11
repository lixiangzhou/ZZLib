//
//  ZZRefreshHeader.swift
//  ZZRefresh
//
//  Created by lixiangzhou on 16/10/27.
//  Copyright © 2016年 lixiangzhou. All rights reserved.
//

import UIKit

class ZZRefreshHeader: ZZRefreshView {

    override var state: ZZRefreshState {
        didSet {
            switch state {
            case .refreshing:
                UIView.animate(withDuration: zz_RefreshConstant.headerRefreshDuration, animations: { 
                    self.scrollView.contentInset.top = zz_RefreshConstant.headerHeight
                })
            default: break
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let offsetY = scrollView.contentOffset.y
        let width = scrollView.bounds.width
        
        let headerHeight = zz_RefreshConstant.headerHeight
        
        // 处理 style
        switch style {
        case .bottom:
            frame = CGRect(x: 0, y: -headerHeight, width: width, height: headerHeight)
        case .scaleToFill:
            var height: CGFloat = min(headerHeight, abs(min(offsetY, 0)))
            let y = min(offsetY, 0);
            height = offsetY < 0 ? abs(offsetY) : 0
            frame = CGRect(x: 0, y: y, width: width, height: height)
        case .top:
            let y = offsetY < -headerHeight ? offsetY : -headerHeight
            frame = CGRect(x: 0, y: y, width: width, height: headerHeight)
        }
        
        // 处理状态变化
        if offsetY > 0 || state == .refreshing {
            return
        }
        print(offsetY)
        if scrollView.isDragging {
            if (state == .normal || state == .releaseRefreshing) && -offsetY < headerHeight {
                state = .willRefreshing
            } else if state == .willRefreshing && -offsetY >= headerHeight {
                state = .releaseRefreshing
            }
        } else if state == .willRefreshing {
            state = .normal
        } else if state == .releaseRefreshing {
            state = .refreshing
        }
    }
}
