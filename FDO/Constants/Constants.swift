//
//  Constants.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public struct Constants {

    struct Security {
        static let authKeychainKey: String = "AUTH_KEYCHAIN_KEY"
    }

    public struct Format {
        public static let serverDateFormat: String = "yyyy-MM-dd"
        public static let serverDateTimeFormat: String = "yyyy-MM-dd'T'HH:mm:ss"
        public static let serverDateTimeTimestamp: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        public static let serverTimeFormat = "HH:mm:ss"
        public static let serverGoogleFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
    }

    public enum Environment: String {
        case develop
        case production
    }

    public static var currentEnvironment: Environment = .develop
}
