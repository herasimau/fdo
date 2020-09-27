//
//  AppCoordinator+Payment.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

protocol PaymentCoordinatorProtocol {
    func startPaymentViewController()
}

extension AppCoordinator: PaymentCoordinatorProtocol {
 
    func startPaymentViewController() {
        let presenter = PaymentPresenter()
        self.changeViewController(actionType: .replace, controller: presenter.start())
    }

}
