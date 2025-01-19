//
//  CreatePostViewModel.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 27.03.2024.
//

import Foundation
import UIKit

enum CreatePostError: Error, LocalizedError {
    case emptyData
    case successfullPosting
    case errorTitle
    case successTitle

    var description: String {
        switch self {
        case .emptyData:
            return "You have to add at least image or text to the post"
        case .successfullPosting:
            return "Congratulations! Your post is successfully added"
        case .errorTitle:
            return "Error"
        case .successTitle:
            return "Success"
        }
    }
}

protocol CreatePostViewModelDelegate: AnyObject, ProgressShowable {
    func processSelectedImage(image: UIImage)
    func showAlert(title: String, with text: String, shouldShowSettings: Bool, completionHandler: (() -> Void)?)
    func finishCreatePostCoordinator()
}

protocol CreatePostViewModelProtocol {
    func selectImage(at viewController: BaseViewController)
    func postFeed(images: [UIImage], message: String)
}

class CreatePostViewModel: CreatePostViewModelProtocol {

    weak var delegate: CreatePostViewModelDelegate?
    private var photoSelectionService: PhotoSelectionService

    init() {
        photoSelectionService = PhotoSelectionService()
        photoSelectionService.delegate = self
    }

    func selectImage(at viewController: BaseViewController) {
        photoSelectionService.selectImage(at: viewController)
    }

    func postFeed(images: [UIImage], message: String) {
        guard images.count >= 2 || !message.isEmpty else {
            showAlert(title: CreatePostError.errorTitle.description, with: CreatePostError.emptyData.description)
            return
        }

        print("=============POSTING=============")

        showAlert(title: CreatePostError.successTitle.description, with: CreatePostError.successfullPosting.description, shouldShowSettings: false) {
            self.delegate?.finishCreatePostCoordinator()
        }
    }

}

extension CreatePostViewModel: PhotoSelectionServiceDelegate {
    func processSelectedImage(image: UIImage) {
        delegate?.processSelectedImage(image: image)
    }

    func showAlert(title: String, with text: String, shouldShowSettings: Bool = false, completionHandler: (() -> Void)? = nil) {
        delegate?.showAlert(title: title, with: text, shouldShowSettings: shouldShowSettings, completionHandler: completionHandler)
    }

    func showProgress(_ title: String?) {
        delegate?.showProgress(title)
    }

    func hideProgress() {
        delegate?.hideProgress()
    }
}
