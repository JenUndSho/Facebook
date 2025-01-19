//
//  SignInViewController.swift
//  Facebook-iOS
//
//  Created by Serhii Liamtsev on 4/15/22.
//

import FBSDKLoginKit
import UIKit

final class SignInViewController: BaseViewController {

    var didSendEventClosure: ((SignInViewController.Event) -> Void)?

    private var signInViewModel: SignInViewModel?
    private var signInView: SignInViewProtocol?

    override func loadView() {
        signInViewModel = SignInViewModel()
        signInViewModel?.delegate = self

        signInView = SignInView()
        signInView?.delegate = self
        view = signInView?.view
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInView?.setCornerRadiusToSignInButton()
    }

}

extension SignInViewController: SignInViewModelDelegate {
    
    func finishSignInCoordinator() {
        hideProgress()
        didSendEventClosure?(.closeSignInPage)
    }
    
}

extension SignInViewController: SignInViewDelegate {
    @objc
    func signIn() {
        signInViewModel?.logInWithFacebook(from: self)
        showProgress(NSLocalizedString("Loading", comment: ""))
    }
}

extension SignInViewController {
    enum Event {
        case closeSignInPage
    }
}
