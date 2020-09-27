//
//  AppCoordinator+Home.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import UIKit

protocol HomeCoordinatorProtocol {
    func startDashBoardViewController()
}

extension AppCoordinator: HomeCoordinatorProtocol {
 
    func startDashBoardViewController() {
        let controller = DashboardPresenter()
        self.changeViewController(actionType: .replace, controller: controller.start())
    }

}
