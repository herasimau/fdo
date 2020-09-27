//
//  AppCoordinator+RecordBook.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

protocol RecordBookCoordinatorProtocol {
    func startRecordBookViewController()
}

extension AppCoordinator: RecordBookCoordinatorProtocol {
 
    func startRecordBookViewController() {
        let presenter = RecordBookPresenter()
        self.changeViewController(actionType: .replace, controller: presenter.start())
    }

}
