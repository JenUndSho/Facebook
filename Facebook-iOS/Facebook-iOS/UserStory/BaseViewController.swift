//
//  BaseViewController.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 17.09.2023.
//

import MBProgressHUD
import UIKit

class BaseViewController: UIViewController {
    var tabBarHeight: CGFloat?
    var uiImagePickerCompletionHandler: ((UIImage) -> Void)?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarHeight = tabBarController?.tabBar.frame.height
        hideKeyboardWhenTappedAround()
    }
}

extension BaseViewController: ProgressShowable {
    func showProgress(_ title: String?) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.isUserInteractionEnabled = true
        indicator.show(animated: true)
    }
    
    func hideProgress() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    func showAlert(with text: String) {
        showAlert(title: "Error", with: text, shouldShowSettings: false, completionHandler: nil)
    }

    func showAlert(title: String, with text: String, shouldShowSettings: Bool, completionHandler: (() -> Void)?) {
        hideProgress()
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler?()
        })

        if shouldShowSettings {
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: nil)
                }
            }
            alert.addAction(settingsAction)
        }

        present(alert, animated: true, completion: { return })
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc 
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let completion = uiImagePickerCompletionHandler, 
            let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            completion(image)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hideProgress()
        picker.dismiss(animated: true, completion: nil)
    }
}
