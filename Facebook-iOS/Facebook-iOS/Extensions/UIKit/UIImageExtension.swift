//
//  UIImageExtension.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 04.02.2024.
//

import Foundation
import UIKit

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}
