//
//  UIColor+Extension.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/27/22.
//

import UIKit

extension UIColor {
    
    @nonobjc class var facebookBlue: UIColor {
        // #4267b2 = rgba(66,103,178,255)
        return UIColor(red: 66.0 / 255.0, green: 103.0 / 255.0, blue: 178.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var facebookBlueCustom: UIColor {
        return UIColor(red: 24.0 / 255.0, green: 119.0 / 225.0, blue: 242.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var lightGrayCustom: UIColor {
        return UIColor(white: 0.9, alpha: 1.0)
    }

    @nonobjc class var grayPlaceholderCustom: UIColor {
        return UIColor(white: 0.6, alpha: 1.0)
    }

    @nonobjc class var grayImagePlaceholder: UIColor {
        return UIColor(red: 196.0 / 255.0, green: 196.0 / 255.0, blue: 196.0 / 255.0, alpha: 1.0)
    }
}
