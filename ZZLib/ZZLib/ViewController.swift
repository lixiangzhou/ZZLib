//
//  ViewController.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/2.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, ZZTableViewMovableCellDelegate {
    
    var tableView: UITableView!
    
        var dataSource = [String]()
//    var dataSource = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.dataSource = self
        
        tableView.zz_movableCell(withMovableViewTag: 10, pressTime: 0.25, movableDelegate: self, edgeScrollSpeed: 3)
        
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
                for i in 0..<20 {
                    dataSource.append("\(i + 1) item")
                }
        
//        for i in 0..<7 {
//            var temp = [String]()
//            for j in 0..<6 {
//                temp.append("\(i + 1) - \(j + 1) item")
//            }
//            dataSource.append(temp)
//        }
        
    }
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource.count
        }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return dataSource.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSource[section].count
//    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
                cell.textLabel?.text = dataSource[indexPath.row]
//        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row]
        
        cell.viewWithTag(10)?.removeFromSuperview()
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.tag = 10
        btn.backgroundColor = UIColor.red
        cell.addSubview(btn)
        
        return cell
    }
    
    func zz_tableViewStartMoveWithOriginData(_ tableView: UITableView) -> [Any] {
        return dataSource
    }
    
    func zz_tableView(_ tableView: UITableView, didMoveWith newData: [Any]) {
                dataSource = newData as! [String]
//        dataSource = newData as! [[String]]
    }
}

