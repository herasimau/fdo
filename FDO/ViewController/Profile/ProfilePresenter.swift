//
//  ProfilePresenter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 23/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

protocol ProfilePresenterProtocol: class {
    func getUserInfo(force: Bool, pullRefresh: Bool)
}

class ProfilePresenter: BasePresenter<ProfileViewController, Void>, ProfilePresenterProtocol {
    private let userService: UserServiceAPI = DIContainer.inject()
    var userInfo: UserInfoModel?

    func getUserInfo(force: Bool, pullRefresh: Bool) {
        userService.getUserInfo(userId: AuthManager.shared.getAuth()?.userId ?? -1, force: force, pullRefresh: pullRefresh) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userInfo):
                self.userInfo = userInfo
                self.view?.reloadText(userInfo: userInfo, pullRefresh: pullRefresh)
            case .failure(let error):
                print(error)
            }
        }
    }
}
