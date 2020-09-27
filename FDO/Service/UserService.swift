//
//  UserService.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftSpinner

protocol UserServiceAPI: Service {

    func getUserInfo(userId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<UserInfoModel>)

}

public class UserService: UserServiceAPI {

    private let userNetworkRepository: UserNetworkRepositoryAPI = DIContainer.inject()
    private let userLocalRepository: UserLocalRepositoryAPI = DIContainer.inject()

    public func getUserInfo(userId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<UserInfoModel>) {
        if !force, let userInfoRealm = userLocalRepository.get(id: String(userId)) {
            completion( .success(userInfoRealm) )
        } else {
            if !pullRefresh {
                SwiftSpinner.show("Загрузка...")
            }
            userNetworkRepository.getUserInfo().done { response in
                if !pullRefresh {
                    SwiftSpinner.hide()
                }
                let userInfoModel = UserInfoMapper.dtoToModel(response)
                self.userLocalRepository.delete(id: String(userId))
                self.userLocalRepository.insert(user: userInfoModel)
                completion( .success(userInfoModel) )
            }.catch { error in
                error.handle(completion: completion)
            }
        }
    }

}
