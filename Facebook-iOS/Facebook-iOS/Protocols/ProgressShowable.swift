//
//  ProgressShowable.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 17.09.2023.
//

import Foundation

protocol ProgressShowable {
   func showProgress(_ title: String?)
   func hideProgress()
}
