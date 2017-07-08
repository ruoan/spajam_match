//
//  UIColorExtension.swift
//  caloriedonate
//
//  Created by ruoan on 2017/06/17.
//  Copyright © 2017年 cobol. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
