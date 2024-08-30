//
//  File.swift
//  
//
//  Created by Hugh on 29/8/2024.
//

import Foundation

extension Session {
    
    fileprivate static let storageKeyName = "TesoroKeyChainSession"
    
    fileprivate static let keyChainQuery: CFDictionary = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrDescription as String: Self.storageKeyName,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true
    ] as [String : Any] as CFDictionary
    
    public func storeInKeyChain(
        then callback: @escaping (Error?) -> Void
    ) -> Void {
        
        Self.removeFromKeyChain { error in
            
            if let error = error {
                callback(error)
                return
            }
            
            guard let secret = self.apiKey.data(using: .utf8) else {
                callback(KeyChainError.unableToFormBytes)
                return
            }
            
            let query: CFDictionary = [
                kSecClass as String: kSecClassGenericPassword,
                kSecValueData as String: secret,
                kSecAttrAccount as String: String(self.agentId),
                kSecAttrLabel as String: String(self.sessionId),
                kSecAttrDescription as String: Self.storageKeyName
            ] as [String : Any] as CFDictionary

            DispatchQueue.global(qos: .background).async {
    
                let status = SecItemAdd(query, nil)
                
                guard status == errSecSuccess else {
                    callback(
                        KeyChainError.unhandledError(status: status)
                    )
                    return
                }

                DispatchQueue.main.async {
                    callback(nil)
                    return
                }
        
                return
                
            }
            return
            
        }
        return
    }

    public func removeFromKeyChain(
        then callback: @escaping (Error?) -> Void
    ) -> Void {
        return Self.removeFromKeyChain(then: callback)
    }
    
    public static func removeFromKeyChain(
        then callback: @escaping (Error?) -> Void
    ) -> Void {
        
        DispatchQueue.global(qos: .background).async {
    
            let status = SecItemDelete(Self.keyChainQuery)
            
            DispatchQueue.main.async {
                
                guard status == errSecSuccess
                        || status == errSecItemNotFound else {
                    callback(
                        KeyChainError.unhandledError(status: status)
                    )
                    return
                }
                
                callback(nil)
                
                return
            }
        }
        
        return
    }
    
    public static func fromKeyChain() throws -> Session? {

        var result: CFTypeRef?
        let status = SecItemCopyMatching(Self.keyChainQuery, &result)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else {
            throw KeyChainError.unhandledError(status: status)
        }

        guard let data = result as? [String: Any],
            let apiKeyData = data[kSecValueData as String] as? Data,
            let apiKey = String(data: apiKeyData, encoding: .utf8),
            let sessionId = data[kSecAttrLabel as String] as? String,
            let agentId = Int(
                data[kSecAttrAccount as String] as? String ?? "nil"
            )
        else {
            throw KeyChainError.unexpectedData
        }
        
        return Session(
            agentId: agentId,
            sessionId: sessionId,
            apiKey: apiKey
        )

    }
    
    #if DEBUG
    static func fromKeyChainSuppressingErrorAsNil() -> Session? {
        
        do {
            return try Self.fromKeyChain()
        } catch {
            print("Keychain error...")
            print(error)
            print("End keychain error")
            return nil
        }
    }
    #endif
    
    public enum KeyChainError: Error {
        case unhandledError(status: OSStatus)
        case unexpectedData
        case unableToFormBytes
    }
    
}
