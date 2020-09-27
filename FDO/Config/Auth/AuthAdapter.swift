//
//  AuthAdapter.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import Alamofire

private class AuthAdapter: RequestAdapter {

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard let auth = AuthManager.shared.getAuth() else { return urlRequest }
        var request = urlRequest
        request.addValue(auth.tokenType + " " + auth.accessToken, forHTTPHeaderField: "Authorization")
        return request
    }
}

// MARK: - NetworkAdapter
public class NetworkAdapter: BaseNetworkAdapter {

    // MARK: - Singleton
    public static var shared = NetworkAdapter(adapter: AuthAdapter())

}
