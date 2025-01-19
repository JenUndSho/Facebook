//
//  UICollectionViewExtension.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 22.05.2024.
//

import Foundation
import UIKit

typealias CellType = UICollectionViewCell & BaseCell

extension UICollectionView {
    func register<T: CellType>(_ type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: type.reuseIdentifier)
    }

    func dequeue<T: CellType>(_ type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.reuseIdentifier, for: indexPath) as? T else {
            return T()
        }

        return cell
    }
}
