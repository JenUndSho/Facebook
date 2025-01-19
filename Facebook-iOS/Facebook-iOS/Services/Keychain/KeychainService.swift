//
//  KeychainService.swift
//  Facebook-iOS
//
//  Created by Evhenii Shovkovyi on 11.10.2023.
//

import Foundation

protocol KeychainServiceProtocol {
    func save(token: String) throws
    func readToken() throws -> Data? 
    func deleteToken() throws
}

enum KeychainConstants: String {
    case facebookService = "facebook.com"
    case facebookUser = "facebookCurrentUser"
    case unableToSave = "Error while saving your data."
    case unableToDelete = "Error while clearing your data."
}

class KeychainService: KeychainServiceProtocol {
    
    enum KeychainError: Error {
        case duplicate
        case notFound
        case unknown(OSStatus)
    }
    
    let service: String
    let account: String
    
    init(account: KeychainConstants, service: KeychainConstants) {
        self.service = service.rawValue
        self.account = account.rawValue
    }
    
    func save(token: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            
            // primary key for kSecClassGenericPassword
            kSecAttrAccount as String: account as AnyObject,
            kSecAttrService as String: service as AnyObject,
            
            // data
            kSecValueData as String: token.data(using: .utf8) as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            print(KeychainError.duplicate)
            return
        }
        
        guard status != errSecItemNotFound else {
            print(KeychainError.notFound)
            return
        }
        
        guard status == errSecSuccess else {
            print(KeychainError.unknown(status))
            return
        }
        
        print("Saved token successfully for \(service) and \(account)")
    }
    
    func readToken() throws -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            
            // primary key for kSecClassGenericPassword
            kSecAttrAccount as String: account as AnyObject,
            kSecAttrService as String: service as AnyObject,
            
            // data
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        _ = SecItemCopyMatching(query as CFDictionary, &result)
        
        return result as? Data
    }
    
    // use it for signOut feature
    func deleteToken() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            
            // primary key for kSecClassGenericPassword
            kSecAttrAccount as String: account as AnyObject,
            kSecAttrService as String: service as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            print(KeychainError.unknown(status))
            return
        }
        
        print("Deleted token successfully for \(service) and \(account)")
    }
    
}
