//
//  UITableView+ZZExtension.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/4.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

/// cell 拖动的代理
protocol ZZTableViewMovableCellDelegate: NSObjectProtocol {
    
    func zz_tableViewStartMoveWithOriginData(_ tableView: UITableView) -> [Any]
    func zz_tableView(_ tableView: UITableView, didMoveWith newData: [Any])
}


extension UITableView {
    
    /// 开启 cell 拖动功能
    ///
    /// - Parameters:
    ///   - tag: cell 中可以拖动的View的 tag, 0 时则整个cell拖动
    ///   - pressTime: 触发拖动的最小时间
    ///   - movableDelegate: 拖动时的代理方法
    ///   - edgeScrollSpeed: 到达边界时滚动的速度，0 时不滚动
    func zz_movableCell(withMovableViewTag tag: Int = 0, pressTime: TimeInterval, movableDelegate: ZZTableViewMovableCellDelegate, edgeScrollSpeed: Double = 0) {
        
        self.movableViewTag = tag
        movableLongPressGesture.minimumPressDuration = pressTime
        movableLongPressGesture.delegate = self
        self.movableDelegate = movableDelegate
        edgeScrollDirection = .top
        self.edgeScrollSpeed = edgeScrollSpeed > 0 ? edgeScrollSpeed : 0
        
        addGestureRecognizer(movableLongPressGesture)
    }
    
    /// 取消拖动功能
    func zz_disableMovableCell() {
        removeGestureRecognizer(movableLongPressGesture)
    }
        
}


extension UITableView: UIGestureRecognizerDelegate {
    // MARK: 监听
    func gestureProcess(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: self)
        
        // 如果超出了范围，就取消返回
        guard let indexPath = indexPathForRow(at: point), isInMovableScrope else {
            cancelOperation()
            return
        }
        
        switch gesture.state {
        case .began:
            if let cell = cellForRow(at: indexPath) {
                startCellSnap = UIImageView(frame: cell.frame)
                startCellSnap.layer.masksToBounds = true
                startCellSnap.image = cell.zz_snapshotImage()
                startCellSnap.layer.shadowOffset = CGSize(width: 5, height: 5)
                startCellSnap.layer.shadowRadius = 5
                
                addSubview(startCellSnap)
                
                cell.isHidden = true
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.startCellSnap.center.y = point.y
                })
                
                startIndexPath = indexPath
            }
        case .changed:
            startCellSnap.center.y = point.y
            
            if shouldEdgeScroll {
                startEdgeScrollTimer()
            } else {
                stopEdgeScrollTimer()
            }
            
            if indexPath != startIndexPath {
                exchangeIndexData(indexPath: indexPath)
            }
        default:
            cancelOperation()
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == movableLongPressGesture {
            return isInMovableScrope
        } else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
    }

    
    // MARK: 辅助
    fileprivate enum EndgeScrollDirection {
        case top, bottom
    }
    
    /// 是否在tag view 所在的范围
    private var isInMovableScrope: Bool {
        let point = movableLongPressGesture.location(in: self)

        if let indexPath = indexPathForRow(at: point),
            let cell = cellForRow(at: indexPath),
            let tagView = cell.viewWithTag(self.movableViewTag) {
            
            let tagFrame = cell == tagView ? cell.frame : cell.convert(tagView.frame, to: self)
            return tagFrame.contains(point)
        } else {
            return false
        }
    }

    /// 拖动时的数据处理
    private func exchangeIndexData(indexPath: IndexPath) {
        guard
            let numberOfSections = dataSource?.numberOfSections!(in: self),
            var originData = movableDelegate?.zz_tableViewStartMoveWithOriginData(self) else {
                return
        }
        
        if numberOfSections > 1 {
            // 同一组
            if startIndexPath.section == indexPath.section,
                var sectionData = originData[startIndexPath.section] as? [Any]
            {
                swap(&sectionData[startIndexPath.row], &sectionData[indexPath.row])
                originData[startIndexPath.section] = sectionData
            } else {    // 不同组
                guard   // 获取cell上的数据
                    var originSectionData = originData[startIndexPath.section] as? [Any],
                    var currentSectionData = originData[indexPath.section] as? [Any] else {
                        return
                }
                let currentIndexData = currentSectionData[indexPath.row]
                let originIndexData = originSectionData[startIndexPath.row]
                
                // 交互数据
                originSectionData[startIndexPath.row] = currentIndexData
                currentSectionData[indexPath.row] = originIndexData
                
                // 更新数据
                originData[startIndexPath.section] = originSectionData
                originData[indexPath.section] = currentSectionData
            }
        } else {    // 只有一组
            swap(&originData[startIndexPath.row], &originData[indexPath.row])
        }
        
        movableDelegate?.zz_tableView(self, didMoveWith: originData)
        
        beginUpdates()
        moveRow(at: startIndexPath, to: indexPath)
        moveRow(at: indexPath, to: startIndexPath)
        endUpdates()
        
        startIndexPath = indexPath
    }

    /// 取消操作
    private func cancelOperation() {
        startCellSnap?.removeFromSuperview()
        stopEdgeScrollTimer()
        
        if
            let startIndexPath = startIndexPath,
            let cell = cellForRow(at: startIndexPath) {
            cell.isHidden = false
        }
    }
    
    /// 开启边界滚动
    private func startEdgeScrollTimer() {
        if timer == nil {
            timer = CADisplayLink(target: self, selector: #selector(edgeScroll))
            timer.add(to: RunLoop.main, forMode: .commonModes)
        }
    }
    
    /// 停止边界滚动
    private func stopEdgeScrollTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 在边界自动滚动
    @objc private func edgeScroll() {
        let factor: CGFloat = 1.5
        switch edgeScrollDirection {
        case .top:
            if contentOffset.y > 0 {
                contentOffset.y -= factor
                startCellSnap.center.y -= factor
            }
        case .bottom:
            if contentOffset.y + bounds.height < contentSize.height {
                contentOffset.y += factor
                startCellSnap.center.y += factor
            }
        }
        
        // 防止边界自动滚动时没有自动更新界面和数据的问题
        if let indexPath = indexPathForRow(at: startCellSnap.center), indexPath != startIndexPath {
            exchangeIndexData(indexPath: indexPath)
        }
    }
    
    /// 是否可以在边界滚动
    private var shouldEdgeScroll: Bool {
        
        if edgeScrollSpeed <= 0 {
            return false
        }
        
        if startCellSnap.frame.minY < contentOffset.y {
            edgeScrollDirection = .top
            return true
        }
        
        if startCellSnap.frame.maxY > frame.height + contentOffset.y {
            edgeScrollDirection = .bottom
            return true
        }
        return false
    }
}


// MARK: - 拖动属性 key
private var longPressGestureKey: Void?
private var startCellSnapKey: Void?
private var startIndexPathKey: Void?
private var edgeScrollDirectionKey: Void?
private var timerKey: Void?
private var movableDelegateKey: Void?
private var edgeScrollSpeedKey: Void?
private var movableViewTagKey: Void?

extension UITableView {
    /// 拖动长按手势
    fileprivate var movableLongPressGesture: UILongPressGestureRecognizer {
        get {
            var longPressGesture = objc_getAssociatedObject(self, &longPressGestureKey) as? UILongPressGestureRecognizer
            if longPressGesture == nil {
                
                longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(gestureProcess))

                objc_setAssociatedObject(self, &longPressGestureKey, longPressGesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            return longPressGesture!
        }
    }
 
    /// 开始拖动时cell的快照
    fileprivate var startCellSnap: UIImageView! {
        set {
            objc_setAssociatedObject(self, &startCellSnapKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &startCellSnapKey) as! UIImageView
        }
    }
    
    /// 开始拖动的IndexPath
    fileprivate var startIndexPath: IndexPath! {
        set {
            objc_setAssociatedObject(self, &startIndexPathKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &startIndexPathKey) as! IndexPath
        }
    }
    
    /// 拖动方向
    fileprivate var edgeScrollDirection: EndgeScrollDirection {
        set {
            objc_setAssociatedObject(self, &edgeScrollDirectionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &edgeScrollDirectionKey) as! EndgeScrollDirection
        }
    }
    
    /// 自动滚动定时器
    fileprivate var timer: CADisplayLink! {
        set {
            objc_setAssociatedObject(self, &timerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &timerKey) as? CADisplayLink
        }
    }
    
    /// 拖动代理
    fileprivate weak var movableDelegate: ZZTableViewMovableCellDelegate! {
        set {
            objc_setAssociatedObject(self, &movableDelegateKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &movableDelegateKey) as! ZZTableViewMovableCellDelegate
        }

    }
    
    /// 边界滚动速度
    fileprivate var edgeScrollSpeed: Double {
        set {
            objc_setAssociatedObject(self, &edgeScrollSpeedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &edgeScrollSpeedKey) as! Double
        }
    }

    /// cell 中可以拖动的View的 tag, 0 时则整个cell拖动
    fileprivate var movableViewTag: Int {
        set {
            objc_setAssociatedObject(self, &movableViewTagKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &movableViewTagKey) as! Int
        }
    }
}
