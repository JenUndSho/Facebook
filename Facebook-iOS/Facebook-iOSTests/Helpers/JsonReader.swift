//
//  JsonReader.swift
//  Facebook-iOSTests
//
//  Created by Evhenii Shovkovyi on 12.03.2024.
//

import Foundation

class JsonReader {

    static func readJson(filename fileName: String) -> NSDictionary {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  if let jsonResult = jsonResult as? NSDictionary {
                            return jsonResult
                  }
              } catch {
                   return NSDictionary()
              }
        }

        return NSDictionary()
    }

}
