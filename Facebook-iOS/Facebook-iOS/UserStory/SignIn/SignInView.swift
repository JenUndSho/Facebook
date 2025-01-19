//
//  SignInView.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 22.02.2024.
//

import Foundation
import UIKit

protocol SignInViewProtocol {
    var delegate: SignInViewDelegate? { get set }
    var view: UIView { get }
    func setCornerRadiusToSignInButton()
}

@objc
protocol SignInViewActionProtocol {
    func didTapSignInButton()
}

@objc
protocol SignInViewDelegate: AnyObject {
    func signIn()
}

class SignInView: UIView {

    weak var delegate: SignInViewDelegate?

    private let imageView = UIImageView()

    private lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        button.backgroundColor = .facebookBlueCustom
        button.clipsToBounds = true
        button.addSubview(buttonLogo)
        button.addSubview(buttonLabel)
        button.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return button
    }()

    private lazy var buttonLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "facebook-icon-login-button")
        return imageView
    }()

    private lazy var buttonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Continue With Facebook", comment: "")
        label.textColor = .white
        label.font = .robotoBoldItalic(size: 23)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init() {
        self.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(imageView)
        addSubview(button)

        backgroundColor = .white

        imageView.image = UIImage(named: "app-lg")

        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            button.heightAnchor.constraint(equalToConstant: 40),
            button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),

            buttonLogo.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            buttonLogo.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10),

            buttonLabel.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -10),
            buttonLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }

}

extension SignInView: SignInViewProtocol {
    func setActionToSignInButton() {
        button.addTarget(delegate, action: #selector(delegate?.signIn), for: .touchUpInside)
    }

    var view: UIView {
        return self
    }

    func setCornerRadiusToSignInButton() {
        button.layer.cornerRadius = button.frame.height / 2
    }
}

extension SignInView: SignInViewActionProtocol {
    func didTapSignInButton() {
        delegate?.signIn()
    }
}
