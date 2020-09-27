//
//  Authentication.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public struct Authentication: Codable {


    public struct Auth: Codable {
        public var accessToken: String
        public var refreshToken: String
        public var userId: Int
        public var tokenType: String
        public var username: String = ""

        public init(accessToken: String, refreshToken: String, userId: Int, tokenType: String) {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.userId = userId
            self.tokenType = tokenType
        }
    }

}
