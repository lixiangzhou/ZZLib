//
//  ZZRefresh.swift
//  ZZRefresh
//
//  Created by lixiangzhou on 16/10/26.
//  Copyright © 2016年 lixiangzhou. All rights reserved.
//


import UIKit

let zz_RefreshConstant = ZZRefreshConstant()

struct ZZRefreshConstant {
    let headerHeight: CGFloat = 50
    let footerHeight: CGFloat = 40
    
    let headerNormalText = "下拉即将刷新..."
    let headerReleaseText = "松开立即刷新..."
    let headerRefreshingText = "正在刷新..."
    
    let footerNormalText = "上拉即将刷新..."
    let footerReleaseText = "松开立即刷新..."
    let footerRefreshingText = "正在刷新..."
    
    let headerRefreshDuration = 0.3
    let footerRefreshDuration = 0.3
}

enum ZZRefreshState {
    case normal                 // 正常状态
    case willRefreshing         // 即将刷新的状态
    case releaseRefreshing      // 释放即可刷新的状态
    case refreshing             // 正在刷新状态
}

enum ZZRefreshViewPositionStyle {
    case bottom
    case top
    case scaleToFill
}
