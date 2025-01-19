//
//  UIFont+Extension.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/27/22.
//

import UIKit

private enum FontName: String, CaseIterable {
    case ralewayLight = "Raleway-Light"
    case ralewayRegular = "Raleway-Regular"
    case ralewayMedium = "Raleway-Medium"
    case ralewaySemiBold = "Raleway-SemiBold"
    case ralewayBold = "Raleway-Bold"
    case pacifico = "Pacifico"
    case robotoBoldItalic = "Roboto-BoldItalic"
    case robotoRegular = "Roboto-Regular"
    case robotoBold = "Roboto-Bold"
}

extension UIFont {
    
    static func ralewayBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: FontName.ralewayBold.rawValue, size: size) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    // MARK: - Raleway Medium
    static var ralewayMedium20: UIFont {
        guard let font = UIFont(name: FontName.ralewayMedium.rawValue, size: 20.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 20.0, weight: .medium)
        }
        return font
    }
    
    static var ralewayMedium18: UIFont {
        guard let font = UIFont(name: FontName.ralewayMedium.rawValue, size: 18.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 18.0, weight: .medium)
        }
        return font
    }
    
    static var pacifico24: UIFont {
        guard let font = UIFont(name: FontName.pacifico.rawValue, size: 24.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 24.0, weight: .medium)
        }
        return font
    }
    
    static var robotoBoldItalic24: UIFont {
        guard let font = UIFont(name: FontName.robotoBoldItalic.rawValue, size: 24.0) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: 24.0, weight: .medium)
        }
        return font
    }
    
    static func robotoBoldItalic(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: FontName.robotoBoldItalic.rawValue, size: size) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }
    
    static func robotoRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: FontName.robotoRegular.rawValue, size: size) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }

    static func robotoBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: FontName.robotoBold.rawValue, size: size) else {
            assertionFailure("Font not found")
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }

    func bold(size: CGFloat) -> UIFont {
        return with(.traitBold, size: size)
    }

    func italic(size: CGFloat) -> UIFont {
        return with(.traitItalic, size: size)
    }

    func boldItalic(size: CGFloat) -> UIFont {
        return with([.traitBold, .traitItalic], size: size)
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits..., size: CGFloat) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
                return self
            }
        return UIFont(descriptor: descriptor, size: size)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits..., size: CGFloat) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
                return self
        }
        return UIFont(descriptor: descriptor, size: size)
    }
}
