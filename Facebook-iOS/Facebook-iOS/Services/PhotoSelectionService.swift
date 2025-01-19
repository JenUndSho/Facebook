//
//  PhotoSelectionService.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 16.04.2024.
//

import AVFoundation
import Foundation
import Photos
import PhotosUI
import UIKit

enum PhotoSelectionError: Error, LocalizedError {
    case noCamera
    case cameraDenied
    case photoLibraryDenied

    var errorDescription: String {
        switch self {
        case .noCamera:
            return "Your device has no camera. Use Gallery instead"
        case .cameraDenied:
            return "Camera is denied. You can enable it in Settings"
        case .photoLibraryDenied:
            return "Photo Library is denied. You can enable it in Settings"
        }
    }
}

protocol PhotoSelectionServiceDelegate: AnyObject, ProgressShowable {
    func processSelectedImage(image: UIImage)
    func showAlert(title: String, with text: String, shouldShowSettings: Bool, completionHandler: (() -> Void)?)

}

protocol PhotoSelectionServiceProtocol {
    func selectImage(at viewController: BaseViewController)
    func presentImagePicker(at viewController: BaseViewController, imagesSource: UIImagePickerController.SourceType)
    func hasCamera() -> Bool
}

class PhotoSelectionService: PhotoSelectionServiceProtocol {

    weak var delegate: PhotoSelectionServiceDelegate?

    func selectImage(at viewController: BaseViewController) {
        let alert = UIAlertController(title: "Select photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { _ in
            self.presentImagePicker(at: viewController, imagesSource: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Select from Gallery", style: .default, handler: { _ in
            self.presentImagePicker(at: viewController, imagesSource: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }

    func presentImagePicker(at viewController: BaseViewController, imagesSource: UIImagePickerController.SourceType) {
        delegate?.showProgress(NSLocalizedString("Loading", comment: ""))
        
        switch imagesSource {
        case .camera:
            guard hasCamera() else {
                DispatchQueue.main.async {
                    self.delegate?.showAlert(title: PhotoSelectionError.noCamera.errorDescription, with: "", shouldShowSettings: true, completionHandler: nil)
                }
                return
            }

            guard AVCaptureDevice.authorizationStatus(for: .video) != .authorized else {
                presentUIImagePickerController(at: viewController, imagesSource: .camera)
                return
            }

            AVCaptureDevice.requestAccess(for: .video, completionHandler: { status in
                guard status else {
                    DispatchQueue.main.async {
                        self.delegate?.showAlert(title: PhotoSelectionError.cameraDenied.errorDescription, with: "", shouldShowSettings: true, completionHandler: nil)
                    }
                    return
                }
                self.presentUIImagePickerController(at: viewController, imagesSource: .camera)
            })

        default:
            if #available(iOS 14.0, *) {
                guard PHPhotoLibrary.authorizationStatus() != .authorized else {
                    presentPHPickerViewController(at: viewController)
                    return
                }

                PHPhotoLibrary.requestAuthorization { status in
                    guard status == .authorized else {
                        DispatchQueue.main.async {
                            self.delegate?.showAlert(title: PhotoSelectionError.photoLibraryDenied.errorDescription,
                                                     with: "",
                                                     shouldShowSettings: true,
                                                     completionHandler: nil)
                        }
                        return
                    }
                    self.presentPHPickerViewController(at: viewController)
                }
            } else {
                presentUIImagePickerController(at: viewController, imagesSource: .photoLibrary)
            }
        }

    }

    func hasCamera() -> Bool {
        return AVCaptureDevice.default(for: .video) != nil
    }

    func presentUIImagePickerController(at viewController: BaseViewController, imagesSource: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.delegate = viewController
            picker.sourceType = imagesSource
            picker.allowsEditing = true

            viewController.uiImagePickerCompletionHandler = { image in
                self.delegate?.processSelectedImage(image: image)
            }
            viewController.present(picker, animated: true)
        }
    }

    @available(iOS 14.0, *)
    func presentPHPickerViewController(at viewController: BaseViewController) {
        DispatchQueue.main.async {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .images

            let pickerVC = PHPickerViewController(configuration: config)
            pickerVC.delegate = self
            pickerVC.isEditing = true
            viewController.present(pickerVC, animated: true)
        }
    }
}

@available(iOS 14, *)
extension PhotoSelectionService: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        delegate?.hideProgress()
        picker.dismiss(animated: true)

        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                self.delegate?.processSelectedImage(image: image)
            }
        }
    }

}
