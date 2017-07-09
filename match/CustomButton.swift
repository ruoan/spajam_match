//
//  CustomButton.swift
//  match
//
//  Created by ruoan on 2017/07/09.
//  Copyright © 2017年 Hiroki Tanaka. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomCustom: UIButton {
    
    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
