//
//  ZZCycleView.swift
//  ZZLib
//
//  Created by lxz on 2018/1/8.
//Copyright © 2018年 lixiangzhou. All rights reserved.
//

import UIKit

public class ZZCycleView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if canCycle {
            resetToCenter()
            startTimer()
        }
    }
    
    // MARK: - Public Property
    /// 循环的个数【必须设置】
    var cycleCount: UInt = 0
    /// 是否可以循环
    var canCycle = true
    /// 循环的时间间隔
    var cycleTimeInterval: TimeInterval = 2
    /// 要显示的内容，ZZCycleViewCell 继承自 UICollectionViewCell【必须设置】
    /// (ZZCycleView, Int) 分别是 ZZCycleView 和 index
    var cellForIndex: ((ZZCycleView, Int) -> ZZCycleViewCell)?
    /// 是否顺时针循环
    var isClockwise = true
    /// 选中了某个 Cell，(ZZCycleView, Int, ZZCycleViewCell) 分别是 ZZCycleView 和 选中的 index，选中的 Cell
    var didSelectCell: ((ZZCycleView, Int, ZZCycleViewCell) -> Void)?
    
    /// 设置新的布局，并从当前位置继续循环，如果开启定时器，会先停止计时器，设置完成后会自动重新开启定时器。如果是 UICollectionViewFlowLayout，
    /// 会同时设置 direction = flowLayout.scrollDirection == .horizontal ? .horizontal : .vertical
    var layout: UICollectionViewLayout {
        set {
            invidateTimer()
            
            let currentIndex = currentIndexPath()
            
            if let flowLayout = newValue as? UICollectionViewFlowLayout {
                direction = flowLayout.scrollDirection == .horizontal ? .horizontal : .vertical
            }
            
            collectionView.setCollectionViewLayout(newValue, animated: false)
            
            /// 从当前位置继续循环
            if let currentIndex = currentIndex {
                collectionView.scrollToItem(at: currentIndex, at: direction == .horizontal ? .centeredHorizontally : .centeredVertically, animated: false)
            }
            
            startTimer()
        }
        get {
            return collectionView.collectionViewLayout
        }
    }
    
    /// 循环的方向
    var direction: Direction = .horizontal
    // MARK: - Private Property
    fileprivate var collectionView: UICollectionView!
    fileprivate var timer: Timer!
    
}

// MARK: - UI
extension ZZCycleView {
    fileprivate func setUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = bounds.size
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        addSubview(collectionView)
    }
}

// MARK: - Action
extension ZZCycleView {
    
}

/// 多个 section 实现的循环，让 ZZCycleView 一直在中间一组循环
fileprivate let sections = 10001
// MARK: - Delegate
extension ZZCycleView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(cycleCount)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if Int(cycleCount) > 0 {
            if canCycle {
                return sections
            } else {
                return 1
            }
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForIndex?(self, indexPath.item)
        assert(cell != nil, "cellForIndex can't be nil")
        return cell!
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ZZCycleViewCell {
            didSelectCell?(self, indexPath.row, cell)
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
}



// MARK: - Helper
extension ZZCycleView {
    fileprivate func resetToCenter() {
        let count = Int(cycleCount)
        if count == 0 {
            return
        } else {
            switch direction {
            case .horizontal:
                let offsetX = collectionView.contentOffset.x
                let width = collectionView.frame.width
                let currentIdx = Int(offsetX / width) % count
                
                if currentIdx == 0  // 第一个的时候，顺时针的时候重置 contentOffset
                    || currentIdx == cycleCount - 1 // 最后一个的时候，逆时针的时候重置 contentOffset
                    || offsetX == 0 // 滚动到了最前面，几乎不会出现，以防万一
                    || offsetX == collectionView.contentSize.width - width  // 滚动到了最后，几乎不会出现，以防万一
                {
                    let singleContentSizeWidth = collectionView.frame.width * CGFloat(count)
                    if isClockwise {
                        // 滚动到中间组的第一个Cell的位置
                        collectionView.contentOffset = CGPoint(x: singleContentSizeWidth * CGFloat(Int(CGFloat(sections) * 0.5)), y: 0)
                    } else {
                        // 滚动到中间组的最后一个Cell的位置
                        collectionView.contentOffset = CGPoint(x: singleContentSizeWidth * CGFloat(Int(CGFloat(sections) * 0.5 + 1)) - collectionView.frame.width, y: 0)
                    }
                }
            case .vertical:
                let offsetY = collectionView.contentOffset.y
                let height = collectionView.frame.height
                let currentIdx = Int(offsetY / height) % count
                
                if currentIdx == 0  // 第一个的时候，顺时针的时候重置 contentOffset
                    || currentIdx == cycleCount - 1 // 最后一个的时候，逆时针的时候重置 contentOffset
                    || offsetY == 0 // 滚动到了最前面，几乎不会出现，以防万一
                    || offsetY == collectionView.contentSize.height - height    // 滚动到了最后，几乎不会出现，以防万一
                {
                    let singleContentSizeHeight = collectionView.frame.height * CGFloat(count)
                    
                    if isClockwise {
                        // 滚动到中间组的第一个Cell的位置
                        collectionView.contentOffset = CGPoint(x: 0, y: singleContentSizeHeight * CGFloat(Int(CGFloat(sections) * 0.5)))
                    } else {
                        // 滚动到中间组的最后一个Cell的位置
                        collectionView.contentOffset = CGPoint(x: 0, y: singleContentSizeHeight * CGFloat(Int(CGFloat(sections + 1) * 0.5)) - collectionView.frame.height)
                    }
                }
            }
        }
    }
    
    fileprivate func currentIndexPath() -> IndexPath? {
        switch direction {
        case .horizontal:
            let x = collectionView.contentOffset.x + collectionView.frame.width * 0.5
            let y = collectionView.frame.height * 0.5
            return collectionView.indexPathForItem(at: CGPoint(x: x, y: y))
        case .vertical:
            let x = collectionView.frame.width * 0.5
            let y = collectionView.contentOffset.y + collectionView.frame.height * 0.5
            return collectionView.indexPathForItem(at: CGPoint(x: x, y: y))
        }
    }
}

// MARK: - Other
public extension ZZCycleView {
    enum Direction {
        case horizontal, vertical
    }
}

// MARK: - Public
public extension ZZCycleView {
    func register(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier identifier: String, for index: Int) -> ZZCycleViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(item: index, section: 0)) as! ZZCycleViewCell
    }
}

public extension ZZCycleView {
    func startTimer() {
        invidateTimer()
        if canCycle && cycleCount > 0 {
            timer = Timer(timeInterval: cycleTimeInterval, repeats: true, block: { timer in
                
                if let currentIndexPath = self.currentIndexPath() {
//                    print(currentIndexPath, IndexPath(item: currentIndexPath.item + (self.isClockwise ? 1 : -1), section: currentIndexPath.section))
                    
                    if self.cycleCount > 1 {
                        // IndexPath 顺时针下一个，逆时针前一个
                        var indexPath = IndexPath(item: currentIndexPath.item + (self.isClockwise ? 1 : -1), section: currentIndexPath.section)
                        if currentIndexPath.item == 0 {
                            if self.isClockwise {   // 当前是第一个并且顺时针，需要重置到最中间组的位置
                                self.resetToCenter()
                                let resetIndexPath = self.currentIndexPath()!
                                indexPath = IndexPath(item: resetIndexPath.item + 1, section: resetIndexPath.section)
                            } else {    // 当前是第一个并且逆时针，需要到前一组的最后一个
                                indexPath = IndexPath(item: Int(self.cycleCount) - 1, section: currentIndexPath.section - 1)
                            }
                        } else if currentIndexPath.item + 1 >= self.cycleCount {
                            if self.isClockwise {   // 当前是最后一个并且顺时针，需要到下一组的第一个
                                indexPath = IndexPath(item: 0, section: currentIndexPath.section + 1)
                            } else {    // 当前是最后一个并且逆时针，需要到当前组的前一个
                                self.resetToCenter()
                                let resetIndexPath = self.currentIndexPath()!
                                indexPath = IndexPath(item: resetIndexPath.item - 1, section: resetIndexPath.section)
                            }
                        }
                        
                        switch self.direction {
                        case .horizontal:
                            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                        case .vertical:
                            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                        }
                    } else if self.cycleCount == 1 {
                        // 只有一个循环的时候，每次需要重置位置
                        self.resetToCenter()
                        let resetIndexPath = self.currentIndexPath()!
                        let indexPath = IndexPath(item: 0, section: resetIndexPath.section + (self.isClockwise ? 1 : -1))
                        
                        switch self.direction {
                        case .horizontal:
                            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                        case .vertical:
                            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                        }
                    }
                }
            })
            RunLoop.current.add(timer, forMode: .commonModes)
        }
    }
    
    func invidateTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
}

public class ZZCycleViewCell: UICollectionViewCell {
}
