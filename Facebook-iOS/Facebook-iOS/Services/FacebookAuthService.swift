//
//  FacebookAuthService.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 12.09.2023.
//

import FBSDKLoginKit
import Foundation

enum FacebookLoginError: Error, LocalizedError {
    case loginCanceled
    case unexpectedAnswer
    case logoutFailed
    case offline

    var description: String {
        switch self {
        case .loginCanceled:
            return "User canceled login"
        case .unexpectedAnswer:
            return "We faced unexpected error on our side. Please try again later"
        case .logoutFailed:
            return "We were unable to log you out. Please try again later"
        case .offline:
            return "The Internet connection appears to be offline."
        }
    }
}

protocol FacebookAuthServiceProtocol {
    func signIn(from: UIViewController?, _ completion: @escaping (Result<String, FacebookLoginError>) -> Void)
    func isUserLoggedIn() -> Bool
}

class FacebookAuthService: FacebookAuthServiceProtocol {

    private var loginManager: FBSDKLoginKit.LoginManager
    private var keychainService = KeychainService(account: KeychainConstants.facebookUser,
                                          service: KeychainConstants.facebookService)

    init() {
        loginManager = LoginManager()
    }
    
    func signIn(from: UIViewController?,
                _ completion: @escaping (Result<String, FacebookLoginError>) -> Void) {
        
        loginManager.logIn(permissions: ["public_profile"], from: from) { result, error in
            guard error == nil else {
                let errorText = error?.localizedDescription ?? ""
                if errorText.contains("offline") {
                    completion(.failure(.offline))
                    return
                } else {
                    completion(.failure(.unexpectedAnswer))
                    return
                }
            }
            guard let result = result, !result.isCancelled else {
                completion(.failure(.loginCanceled))
                return
            }
            
            completion(.success(AccessToken.current?.tokenString ?? ""))
        }
        
    }

    func signOut(_ completion: @escaping (Result<String, FacebookLoginError>) -> Void) {
        loginManager.logOut()
        if (AccessToken.current?.tokenString) != nil {
            completion(.failure(.logoutFailed))
        } else {
            completion(.success("You were successfully logged out"))
        }

    }

    func isUserLoggedIn() -> Bool {
        return (try? keychainService.readToken()) != nil && AccessToken.current?.tokenString != nil
    }

}
