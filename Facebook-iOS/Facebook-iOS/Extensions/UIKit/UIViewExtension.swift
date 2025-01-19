//
//  UIViewExtension.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 04.02.2024.
//

import Foundation
import UIKit

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case left, right, top, bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .left: 
            border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height)
        case .right: 
            border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height)
        case .top: 
            border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness)
        case .bottom: 
            border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        }
        
        layer.addSublayer(border)
    }
}
