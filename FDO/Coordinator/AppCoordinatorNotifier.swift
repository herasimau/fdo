//
//  AppCoordinatorNotifier.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Foundation
import PromiseKit

protocol AppCoordinatorDelegate: AnyObject {

    func willBeRemove(controller: UIViewController) -> Promise<Bool>
}

class AppCoordinatorNotifier: NSObject {

    private static var observers: [String: AppCoordinatorDelegate] = [:]

    public static func register<T: AppCoordinatorDelegate>(_ observerType: String, observer: T) {
        observers[observerType] = observer
    }

    public static func register<T: AppCoordinatorDelegate>(_ observerType: Any.Type, observer: T) {
        let className = String(describing: type(of: observerType.self))
        observers[className] = observer
    }

    public static func unregister(_ observerType: String) {
        observers.removeValue(forKey: observerType)
    }

    public static func unregister(_ observerType: Any.Type) {
        let className = String(describing: type(of: observerType.self))
        observers.removeValue(forKey: className)
    }

    public static func willBeRemove(controller: UIViewController?) -> Promise<Bool> {

        if let ctrl = controller {
            var change: Bool = true
            var loadingPromises: [Promise<Void>] = []
            for element in AppCoordinatorNotifier.observers {
                loadingPromises.append(element.value.willBeRemove(controller: ctrl).done {(canChange: Bool) in
                    change = change && canChange
                })
            }

            return when(fulfilled: loadingPromises).map {_ -> Bool in
                return change
            }
        } else {
            return .value(true)
        }

    }
}
