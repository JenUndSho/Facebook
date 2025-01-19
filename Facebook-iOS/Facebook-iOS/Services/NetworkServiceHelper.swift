//
//  NetworkServiceHelper.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 18.03.2024.
//

import FBSDKCoreKit
import Foundation

class NetworkServiceHelper {

    public static func executeGraphRequest<T: DataModelProtocol>(type: T.Type, request: GraphRequest, _ completion: @escaping (Result<T, FacebookNetworkError>) -> Void) {

        request.start { _, result, error in
            guard error == nil else {
                let errorText = error?.localizedDescription ?? ""
                if errorText.contains("offline") {
                    completion(.failure(.offline))
                    return
                } else {
                    completion(.failure(.generalNetwork))
                    return
                }
            }

            if let result = result as? NSDictionary {
                do {
                    let parsedObject = try type.init(dictionary: result)
                    completion(.success(parsedObject))
                } catch {
                    completion(.failure(.unknown))
                    print(error)
                }
            }
        }

    }

    public static func removeGraphHostAndVersion(from url: URL) -> String {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return "" }
        urlComponents.scheme = nil
        urlComponents.host = nil
        return urlComponents.url?.absoluteString ?? ""
    }

}
