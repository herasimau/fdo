//
//  UIImageExtension.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 14/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    class func scale(image: UIImage, by scale: CGFloat) -> UIImage? {
        let size = image.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIImage.resize(image: image, targetSize: scaledSize)
    }

    func withColor(_ color: UIColor) -> UIImage {
          UIGraphicsBeginImageContextWithOptions(size, false, scale)
          guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }
          color.setFill()
          ctx.translateBy(x: 0, y: size.height)
          ctx.scaleBy(x: 1.0, y: -1.0)
          ctx.clip(to: CGRect(x: 0, y: 0, width: size.width, height: size.height), mask: cgImage)
          ctx.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
          guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }
          UIGraphicsEndImageContext()
          return colored
     }

    static func loadImageFromPath(_ path: NSString) -> UIImage? {
        let image = UIImage(contentsOfFile: path as String)
        return image ?? nil
    }

    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
