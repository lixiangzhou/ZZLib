//
//  ZZRefresh.swift
//  ZZRefresh
//
//  Created by lixiangzhou on 16/10/26.
//  Copyright © 2016年 lixiangzhou. All rights reserved.
//


import UIKit

public let zz_RefreshConstant = ZZRefreshConstant()

public struct ZZRefreshConstant {
    public let headerHeight: CGFloat = 50
    public let footerHeight: CGFloat = 40
    
    public let headerNormalText = "下拉即将刷新..."
    public let headerReleaseText = "松开立即刷新..."
    public let headerRefreshingText = "正在刷新..."
    
    public let footerNormalText = "上拉即将刷新..."
    public let footerReleaseText = "松开立即刷新..."
    public let footerRefreshingText = "正在刷新..."
    
    public let headerRefreshDuration = 0.3
    public let footerRefreshDuration = 0.3
}

public enum ZZRefreshState {
    case normal                 // 正常状态
    case willRefreshing         // 即将刷新的状态
    case releaseRefreshing      // 释放即可刷新的状态
    case refreshing             // 正在刷新状态
}

public enum ZZRefreshViewPositionStyle {
    case bottom
    case top
    case scaleToFill
}
