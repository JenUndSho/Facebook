//
//  GradientColor.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 04.02.2024.
//

import Foundation
import UIKit

class GradientColor {
    
//    static func gradientColor(bounds: CGRect, colors: [CGColor]) -> UIColor? {
//        let gradientLayer = getGradientLayer(bounds: bounds, colors: colors)
//        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
//        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return UIColor(patternImage: image!)
//    }
    
    static func getGradientLayer(bounds: CGRect, colors: [CGColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors  // [UIColor.blue.cgColor,UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
    
}
