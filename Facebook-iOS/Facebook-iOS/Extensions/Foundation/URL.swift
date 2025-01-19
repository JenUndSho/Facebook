//
//  URL.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 22.02.2024.
//

import Foundation

extension URL {

    static func getUrl(_ string: String) -> URL {
        return URL(string: string) ?? URL(fileURLWithPath: "")
    }
}
