//
//  AppCoordinator+Login.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import UIKit

protocol LoginCoordinatorProtocol {
    func startLoginViewController()
}

extension AppCoordinator: LoginCoordinatorProtocol {

    func startLoginViewController() {
        let controller = LoginViewController()
        self.changeViewController(actionType: .replace, controller: controller)
    }

}
