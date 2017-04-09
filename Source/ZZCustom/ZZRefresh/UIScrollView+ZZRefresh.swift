//
//  UIScrollView+ZZRefresh.swift
//  UIScrollView+ZZRefresh
//
//  Created by lixiangzhou on 16/10/26.
//  Copyright © 2016年 lixiangzhou. All rights reserved.
//


import UIKit

private var zzRefresh_HeaderKey: Void?
private var zzRefresh_FooterKey: Void?

extension UIScrollView {
    
    var header: ZZRefreshHeader? {
        set {
            guard let header = newValue else {
                return
            }
            self.header?.removeFromSuperview()
            addSubview(header)
            objc_setAssociatedObject(self, &zzRefresh_HeaderKey, header, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            return objc_getAssociatedObject(self, &zzRefresh_HeaderKey) as? ZZRefreshHeader
        }
    }
    
    var footer: ZZRefreshFooter? {
        set {
            guard let footer = newValue else {
                return
            }
            self.footer?.removeFromSuperview()
            addSubview(footer)
            objc_setAssociatedObject(self, &zzRefresh_FooterKey, footer, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &zzRefresh_FooterKey) as? ZZRefreshFooter
        }
    }
}
