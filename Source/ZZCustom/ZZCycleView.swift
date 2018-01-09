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
    var cycleCount: UInt = 0
    var canCycle = true
    var cycleTimeInterval: TimeInterval = 2
    var cellForIndex: ((ZZCycleView, Int) -> ZZCycleViewCell)?
    
    var layout: UICollectionViewFlowLayout {
        set {
            if collectionView == nil {
                setUI()
            }
            collectionView.setCollectionViewLayout(newValue, animated: false)
        }
        get {
            return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        }
    }
    // MARK: - Private Property
    fileprivate var collectionView: UICollectionView!
    fileprivate var timer: Timer!
    fileprivate var direction: UICollectionViewScrollDirection {
        return layout.scrollDirection
    }
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

fileprivate let sections = 1001
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
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        print(currentIndexPath())
        if canCycle {
            resetToCenter()
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
                
                if currentIdx == 0
                    || offsetX == 0
                    || offsetX == collectionView.contentSize.width - width
                {
                    collectionView.contentOffset = CGPoint(x: collectionView.frame.width * CGFloat(count) * CGFloat(Int(CGFloat(sections) * 0.5)), y: 0)
                }
            case .vertical:
                let offsetY = collectionView.contentOffset.y
                let height = collectionView.frame.height
                let currentIdx = Int(offsetY / height) % count
                
                if currentIdx == 0
                    || offsetY == 0
                    || offsetY == collectionView.contentSize.height - height
                {
                    collectionView.contentOffset = CGPoint(x: 0, y: collectionView.frame.height * CGFloat(count) * CGFloat(Int(CGFloat(sections) * 0.5)))
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
extension ZZCycleView {

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
                    print(currentIndexPath, IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section))
                    
                    if self.cycleCount > 1 {
                        var indexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
                        
                        if currentIndexPath.item == 0 {
                            self.resetToCenter()
                            let resetIndexPath = self.currentIndexPath()!
                            indexPath = IndexPath(item: resetIndexPath.item + 1, section: resetIndexPath.section)
                        } else if currentIndexPath.item + 1 >= self.cycleCount {
                            indexPath = IndexPath(item: 0, section: currentIndexPath.section + 1)
                        }
                        switch self.direction {
                        case .horizontal:
                            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                        case .vertical:
                            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                        }
                    } else if self.cycleCount == 1 {
                        self.resetToCenter()
                        let resetIndexPath = self.currentIndexPath()!
                        let indexPath = IndexPath(item: 0, section: resetIndexPath.section + 1)
                        
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
