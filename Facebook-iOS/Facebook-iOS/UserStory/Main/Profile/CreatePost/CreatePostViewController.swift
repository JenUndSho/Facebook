//
//  CreatePostViewController.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 27.03.2024.
//

import Foundation
import UIKit

class CreatePostViewController: BaseViewController {
    var didSendEventClosure: ((CreatePostViewController.Event) -> Void)?

    private var createPostViewModel: CreatePostViewModel?
    private var createPostView: CreatePostViewProtocol?
    private var user: User?

    convenience init(user: User?) {
        self.init()
        self.user = user
    }

    override func loadView() {
        createPostViewModel = CreatePostViewModel()
        createPostViewModel?.delegate = self

        createPostView = CreatePostView()
        createPostView?.delegate = self
        view = createPostView?.view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        createPostView?.setUserData(with: user ?? User(firstName: "Test", lastName: "Test"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createPostView?.setUpTabBarAppearance(navigationController: navigationController, shouldShow: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        createPostView?.setUpTabBarAppearance(navigationController: navigationController, shouldShow: true)
    }

    private func setUpLayout() {
        createPostView?.setUpNavigationBar(for: navigationItem)
    }
}

extension CreatePostViewController: CreatePostViewModelDelegate {
    func processSelectedImage(image: UIImage) {
        createPostView?.addImageToCreatePostImages(image: image)
        hideProgress()
    }

    func finishCreatePostCoordinator() {
        didSendEventClosure?(.closeCreatePostPage)
    }
}

extension CreatePostViewController {
    enum Event {
        case closeCreatePostPage
    }
}

extension CreatePostViewController: CreatePostViewDelegate {
    @objc
    func selectImage() {
        createPostViewModel?.selectImage(at: self)
        print("Select Image Tapped")
    }

    @objc
    func postFeed(images: [UIImage], message: String) {
        createPostViewModel?.postFeed(images: images, message: message)
        print("Create Post Tapped")
    }

    @objc
    func displayAlert(with text: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Info", with: text, shouldShowSettings: false, completionHandler: nil)
        }
    }
}
