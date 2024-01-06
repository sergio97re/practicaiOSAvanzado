//
//  SecureDataProvider.swift
//  PracticaFinaliOSAvanzado
//
//  Created by Sergio Reina Montes on 03/01/2024.
//

import Foundation
import KeychainSwift

//MARK: - PROTOCOL -
protocol SecureDataProviderProtocol {
    func save(token: String)
    func getToken() -> String?
}

final class SecureDataProvider: SecureDataProviderProtocol {
    private let keychain = KeychainSwift()
    
    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }
    
    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }
    
    func getToken() -> String? {
        keychain.get(Key.token)
    }
    
}
