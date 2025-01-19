//
//  BaseCell.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 21.05.2024.
//

import Foundation
import UIKit

protocol BaseCell {
    static var reuseIdentifier: String { get }
}

extension BaseCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
