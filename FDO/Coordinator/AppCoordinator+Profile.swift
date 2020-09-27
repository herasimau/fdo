//
//  AppCoordinator+Profile.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

protocol ProfileCoordinatorProtocol {
    func startProfileViewController()
}

extension AppCoordinator: ProfileCoordinatorProtocol {
 
    func startProfileViewController() {
        let presenter = ProfilePresenter()
        self.changeViewController(actionType: .replace, controller: presenter.start())
    }

}
