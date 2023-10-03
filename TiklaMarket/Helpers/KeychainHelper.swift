//
//  KeyChainHelper.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 12.09.2023.
//

import Foundation
import Security

class KeychainHelper{
    
    static func save(_ data: Data, label: String) {
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrLabel: label,//password tag'i
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }
    
    static func read(label: String) -> Data? {
        
        let query = [
            kSecAttrLabel: label,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
}
