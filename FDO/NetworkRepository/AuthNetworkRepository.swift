//
//  AuthNetworkRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit

protocol AuthNetworkRepositoryAPI: Repository {

    func authenticate(username: String, password: String) -> Promise<NSDictionary>

    func refresh() -> Promise<RefreshAuthDTO>?

}

class AuthNetworkRepository: NSObject, AuthNetworkRepositoryAPI {

    internal var networkAdapter: NetworkAdapterAPI = NetworkAdapter.shared
    internal var unauthenticatedNetworkAdapter: NetworkAdapterAPI = UnauthenticatedNetworkAdapter.shared
    private let baseUrl: String

    init(host: String) {
        self.baseUrl = host + "users/"
    }

    public func authenticate(username: String, password: String) -> Promise<NSDictionary> {
        return unauthenticatedNetworkAdapter.requestFormData(request: NetworkRequest(
            url: self.baseUrl + "signin",
            method: .post,
            authorizationRequired: false),
            multipartFormData: { multipartFormData in
                multipartFormData.append(username.data(using: .utf8)!, withName: "username")
                multipartFormData.append(password.data(using: .utf8)!, withName: "password")
            }
        )
    }

    public func refresh() -> Promise<RefreshAuthDTO>? {
        if let auth = AuthManager.shared.getAuth() {
            let request =  NetworkCodableRequest(baseUrl: self.baseUrl, path: "refresh", method: .get)
            request.headers = ["Authorization": auth.tokenType + " " + auth.refreshToken]
            request.authorizationRequired = false
            return unauthenticatedNetworkAdapter.requestObject(request: request)
        } else {
            AppCoordinator.shared().backToLogin()
        }
        return nil
    }

}
