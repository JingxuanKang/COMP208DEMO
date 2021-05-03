//
//  Extension.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/9.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(
            red: CGFloat((hex & 0xff0000) >> 16)/255,
            green: CGFloat((hex & 0x00ff00) >> 8)/255,
            blue: CGFloat(hex & 0x0000ff)/255,
            alpha: alpha
        )
    }
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    class func random() -> UIColor {
        return UIColor(
            red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
            green: CGFloat(arc4random()) / CGFloat(UInt32.max),
            blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
            alpha: 1.0
        )
    }
}

extension UIResponder {
    var currentViewController: UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.currentViewController
        } else {
            return nil
        }
    }
}

extension UIImage {
    class func image(color: UIColor, size: CGSize = .init(width: 10, height: 10)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(.init(origin: .zero, size: size))
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func colored(_ color: UIColor) -> UIImage? {
        let img = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale)
        color.set()
        img.draw(in: .init(origin: .zero, size: img.size))
        let outImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outImage
    }
    
    func resize(to targetSize: CGSize) -> UIImage? {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

