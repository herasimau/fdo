//
//  AppCoordinator+Mail.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

protocol MailCoordinatorProtocol {
    func startMailViewController()
}

extension AppCoordinator: MailCoordinatorProtocol {
 
    func startMailViewController() {
        let presenter = MailPresenter()
        self.changeViewController(actionType: .replace, controller: presenter.getMailController())
    }

}
