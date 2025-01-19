//
//  UIImageExtension.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 01.01.2024.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from url: URL, completionIfFailed: @escaping () -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completionIfFailed()
                }
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
    
    open override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
    
}
