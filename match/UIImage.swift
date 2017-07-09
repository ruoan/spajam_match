//
//  UIImage.swift
//  match
//
//  Created by ruoan on 2017/07/09.
//  Copyright © 2017年 Hiroki Tanaka. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        //let widthRatio = _size.width / size.width
        //let heightRatio = _size.height / size.height
        //let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: _size.width, height: _size.height)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, true, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
