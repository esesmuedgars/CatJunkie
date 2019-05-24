//
//  KeychainService.swift
//  CatJunkie-iOS
//
//  Created by e.vanags on 24/05/2019.
//  Copyright © 2019 esesmuedgars. All rights reserved.
//

import Foundation
import Security

enum KeychainError: Error {
    case dataConversionError
    case statusUnhandledError(_ status: OSStatus)
}

extension KeychainError {
    var userDescription: String {
        switch self {
        case .dataConversionError:
            return "Keychain returned error while converting data to string."
        case .statusUnhandledError(let status):
            return "Keychain returned unhandeled error. Status: \(status)."
        }
    }
}

final class KeychainService {
    
    static var `default` = KeychainService()

    private var bundleIdentifier = Bundle.main.bundleIdentifier

    private init() {}

    init(_ bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
    }

    func setValue(_ value: String) throws {
        let encodedPassword = value.data(using: .utf8)!

        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = bundleIdentifier

        var status = SecItemUpdate(query as CFDictionary, [:] as CFDictionary)

        switch status {
        case errSecSuccess:
            var attributesToUpdate: [CFString: Any] = [:]
            attributesToUpdate[kSecValueData] = encodedPassword

            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)

            if status != errSecSuccess {
                throw KeychainError.statusUnhandledError(status)
            }
        case errSecItemNotFound:
            query[kSecValueData] = encodedPassword

            status = SecItemAdd(query as CFDictionary, nil)

            if status != errSecSuccess {
                throw KeychainError.statusUnhandledError(status)
            }
        default:
            throw KeychainError.statusUnhandledError(status)
        }
    }

    public func getValue() throws -> String? {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnAttributes] = kCFBooleanTrue
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecAttrAccount] = bundleIdentifier

        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard let item = result as? [CFString: Any], let data = item[kSecValueData] as? Data, let password = String(data: data, encoding: .utf8) else {
                throw KeychainError.dataConversionError
            }

            return password
        case errSecItemNotFound:
            break
        default:
            throw KeychainError.statusUnhandledError(status)
        }

        return nil
    }

    public func removeValue() throws {
        var query: [CFString: Any] = [:]
        query[kSecClass] = kSecClassGenericPassword
        query[kSecAttrAccount] = bundleIdentifier

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess {
            throw KeychainError.statusUnhandledError(status)
        }
    }
}
