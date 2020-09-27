//
//  UserNetworkRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit

protocol UserNetworkRepositoryAPI: Repository {
 
    func getUserInfo() -> Promise<UserInfoDTO>

}

class UserNetworkRepository: UserNetworkRepositoryAPI {

    private let networkAdapter: NetworkAdapterAPI = NetworkAdapter.shared
    private let baseUrl: String

    init(host: String) {
        self.baseUrl = host + "users/"
    }

    func getUserInfo() -> Promise<UserInfoDTO> {
        let request = BaseNetworkRequest(baseUrl: baseUrl, path: "me/info", method: .get)
        return networkAdapter.requestObject(request: request)
    }

}
