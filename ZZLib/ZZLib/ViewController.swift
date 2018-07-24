//
//  ViewController.swift
//  ZZLib
//
//  Created by lixiangzhou on 2017/4/2.
//  Copyright © 2017年 lixiangzhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        /*
         case none
         
         case decimal
         
         case currency
         
         case percent
         
         case scientific
         
         case spellOut
         
         @available(iOS 9.0, *)
         case ordinal
         
         @available(iOS 9.0, *)
         case currencyISOCode
         
         @available(iOS 9.0, *)
         case currencyPlural
         
         @available(iOS 9.0, *)
         case currencyAccounting
         */
        
        let nf = NumberFormatter()
        let number = NSNumber(value: 123456789)
        
        nf.locale = Locale(identifier: "zh_Hans_CN")
        nf.numberStyle = .currency
        nf.positiveSuffix = "元"
        nf.positivePrefix = "AA"
        nf.maximumFractionDigits = 5
        nf.minimumFractionDigits = 5
        print(nf.string(from: number))
        print("=============================")
        
        print(NumberFormatter.localizedString(from: number, number: .none))
        print(NumberFormatter.localizedString(from: number, number: .decimal))
        print(NumberFormatter.localizedString(from: number, number: .currency))
        print(NumberFormatter.localizedString(from: number, number: .percent))
        print(NumberFormatter.localizedString(from: number, number: .scientific))
        print(NumberFormatter.localizedString(from: number, number: .spellOut))
        print(NumberFormatter.localizedString(from: number, number: .ordinal))
        print(NumberFormatter.localizedString(from: number, number: .currencyISOCode))
        print(NumberFormatter.localizedString(from: number, number: .currencyPlural))
        print(NumberFormatter.localizedString(from: number, number: .currencyAccounting))
    }
    
    
}
