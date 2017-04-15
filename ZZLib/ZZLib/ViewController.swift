//
//  ViewController.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/2.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
//        tableView.contentInset = UIEdgeInsetsMake(40, 0, 40, 0)
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ID")
        
        tableView.header = ZZRefreshHeader(target: self, action: #selector(headerAction), style: .bottom)
        tableView.footer = ZZRefreshFooter(target: self, action: #selector(footerAction), style: .bottom)
        
        for i in 0..<10 {
            self.dataList.append(i)
        }
    }
    
    func headerAction() {
        for _ in 0..<10 {
            self.dataList.append(self.dataList.first! - 1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.tableView.header?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func footerAction() {
        let last = self.dataList.last!
        for i in 0..<10 {
            self.dataList.append(last + i + 1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.tableView.footer?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    var dataList = [Int]()
}

extension ViewController: UIScrollViewDelegate {
    
    func test() {
        let scrollView = view.zz_add(subview: UIScrollView(frame: CGRect(x: 0, y: 20, width: view.zz_width, height: view.zz_height - 20))) as! UIScrollView
        scrollView.backgroundColor = UIColor.red
        scrollView.contentSize = scrollView.frame.size
        scrollView.contentInset = UIEdgeInsetsMake(10, 20, 30, 40)
        scrollView.zz_add(subview: UIView(frame: scrollView.bounds)).backgroundColor = UIColor.blue
        scrollView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("offset - \(scrollView.contentOffset)")
        print("contentsize - \(scrollView.contentSize)")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath)
        
        cell.textLabel?.text = "item \(self.dataList[indexPath.row])"
        
        return cell
    }
}

