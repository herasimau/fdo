//
//  KeychainManager.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import KeychainAccess

public class KeychainManager {

    static private var keychain: KeychainAccess.Keychain? = {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return nil }
        return KeychainAccess.Keychain(service: bundleIdentifier)
    }()

    public class func stringFor(key: String) -> String? {
        return keychain?[key]
    }

    public class func setString(value: String?, for key: String) {
        keychain?[key] = value
    }

    public class func set<T>(value: T?, for key: String) where T: Codable {
        if let data = try? JSONEncoder().encode(value) {
            try? keychain?.set(data, key: key)
        }
    }

    public class func valueFor<T>(key: String) -> T? where T: Codable {
        if let data = try? keychain?.getData(key) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }

    public class func removeValueFor(key: String) {
        try? keychain?.remove(key)
    }

    public class func removeAll() {
        try? keychain?.removeAll()
    }
}
