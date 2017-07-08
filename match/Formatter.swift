//
//  Formatter.swift
//  match
//
//  Created by ruoan on 2017/07/09.
//  Copyright © 2017年 Hiroki Tanaka. All rights reserved.
//

import Foundation

extension Int {
    // Intを三桁ごとにカンマが入ったStringへ
    var decimalStr: String {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
        
        return decimalFormatter.string(from: self as NSNumber)!
    }
}
