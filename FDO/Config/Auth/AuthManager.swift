//
//  AuthManager.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public class AuthManager {

    private init() {}
    public static var shared: AuthManager = AuthManager()
    private var auth: Authentication.Auth?

    public func getAuth() -> Authentication.Auth? {
        guard let authentication = auth else {
            auth = KeychainManager.valueFor(key: Constants.Security.authKeychainKey)
            return auth
        }
        return authentication
    }

    public func save(auth: Authentication.Auth) {
        KeychainManager.set(value: auth, for: Constants.Security.authKeychainKey)
        self.auth = auth
    }

    public func reset() {
        auth = nil
        KeychainManager.removeValueFor(key: Constants.Security.authKeychainKey)
    }

}
