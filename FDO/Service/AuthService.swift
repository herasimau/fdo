//
//  AuthService.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit

protocol AuthServiceAPI: Service {

    func logout()
    func isValidAuthentication() -> Bool
    func authenticate(username: String, password: String, completion: @escaping CustomCompletion<NSDictionary>)
    func refresh(completion: @escaping CustomCompletion<RefreshAuthDTO>)

}

public class AuthService: AuthServiceAPI {

    private let networkAdapter =  NetworkAdapter.shared
    private let authNetworkRepository: AuthNetworkRepositoryAPI = DIContainer.inject()

    public init() {
        self.networkAdapter.delegate = self
    }

    func logout() {
        AuthManager.shared.reset()
    }

    func isValidAuthentication() -> Bool {
        return true
    }

    func authenticate(username: String, password: String, completion: @escaping CustomCompletion<NSDictionary>) {
        authNetworkRepository.authenticate(username: username, password: password).done { [weak self] result in
            guard self != nil else { return }
            guard let accessToken = result["access_token"] as? String else { throw ErrorDTO(message: "Authentication failed") }
            guard let refreshToken = result["refresh_token"] as? String else { throw ErrorDTO(message: "Authentication failed") }
            guard let userId = result["user_id"] as? String else { throw ErrorDTO(message: "Authentication failed") }

            let tokenType = "Bearer"
            let auth = Authentication.Auth(accessToken: accessToken, refreshToken: refreshToken, userId: Int(userId) ?? -1,tokenType: tokenType)
            AuthManager.shared.save(auth: auth)
            completion(.success(result))
        }.catch { error in
            error.handle(completion: completion)
        }
    }

    func refresh(completion: @escaping CustomCompletion<RefreshAuthDTO>) {
        authNetworkRepository.refresh()?.done { [weak self] result in
            guard self != nil else { return }
            let tokenType = "Bearer"
            let auth = Authentication.Auth(accessToken: result.access_token, refreshToken: result.refresh_token, userId: Int(result.user_id) ?? -1, tokenType: tokenType)
            AuthManager.shared.save(auth: auth)
            completion(.success(result))
        }.catch { error in
            error.handle(completion: completion)
            AppCoordinator.shared().backToLogin()
        }
    }

}


extension AuthService: NetworkAdapterDelegate {
 
    public func networkAdapterDidDetectUnauthorized(_ networkAdapter: NetworkAdapterAPI) {
        switch networkAdapter {
        case is NetworkAdapter:
            self.logout()
        default:
            break
        }
    }

    public func networkAdapterTryToRefresh(_ networkAdapter: NetworkAdapterAPI, completion: @escaping (Bool) -> Void) {
        switch networkAdapter {
        case is NetworkAdapter:
            return refreshNetworkAdapter(completion: completion)
        default:
            return completion(false)
        }
    }

    private func refreshNetworkAdapter(completion: @escaping (Bool) -> Void) {
        authNetworkRepository.refresh()?.done { result in
            guard var auth = AuthManager.shared.getAuth() else { return completion(false) }
            auth.accessToken = result.access_token
            AuthManager.shared.save(auth: auth)
            completion(true)
        }.catch {error in
            completion(false)
            AppCoordinator.shared().backToLogin()
        }
    }
}
