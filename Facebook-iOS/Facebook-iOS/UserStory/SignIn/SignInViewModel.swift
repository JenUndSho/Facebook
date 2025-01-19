//
//  SignInViewModel.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 16.08.2023.
//

import FBSDKLoginKit
import Foundation

protocol SignInViewModelDelegate: AnyObject {
    func showAlert(with text: String)
    func finishSignInCoordinator()
}

protocol SignInViewModelProtocol {
    var facebookAuthService: FacebookAuthService { get }
    func logInWithFacebook(from: UIViewController?)
}

class SignInViewModel: SignInViewModelProtocol {
    
    weak var delegate: SignInViewModelDelegate?
    var facebookAuthService = FacebookAuthService()
    var keychainService = KeychainService(account: KeychainConstants.facebookUser,
                                          service: KeychainConstants.facebookService)
    
    func logInWithFacebook(from: UIViewController?) {
        print("logInWithFacebook Request")
        facebookAuthService.signIn(from: from) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.showAlert(with: error.description)
            case .success(let accessToken):
                do {
                    try self?.keychainService.save(token: accessToken)
                } catch {
                    self?.delegate?.showAlert(with: KeychainConstants.unableToSave.rawValue)
                }
                self?.delegate?.finishSignInCoordinator()
            }
        }
    }
}
