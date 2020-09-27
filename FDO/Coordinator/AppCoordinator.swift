//
//  AppCoordinator.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

protocol AppCoordinatorProtocol {

    func changeViewController(actionType: AppCoordinator.Actions, controller: UIViewController)
    func changeViewController(actionType: AppCoordinator.Actions, controller: UIViewController, skipCheck: Bool)
    func changeViewController(coordinator: Coordinator)
    func changeViewController(coordinator: Coordinator, skipCheck: Bool)
    func back(ignoreCheck: Bool)
}

protocol BackController {
    func backCalled()
}

class Coordinator {

    private var controller: UIViewController!
    private var actionType: AppCoordinator.Actions!

    init(controller: UIViewController, actionType: AppCoordinator.Actions) {
        self.controller = controller
        self.actionType = actionType

    }

    public func getController() -> UIViewController {
        return controller
    }

    public func getActionType() -> AppCoordinator.Actions {
        return actionType
    }

}

class AppCoordinator {

    var delegateArray = [String: NavigationObserverDelegate]()
    private static var instance: AppCoordinator = AppCoordinator()
    var homeViewController: HomeViewController!
    private var coordinators: [Coordinator] = [Coordinator]()
    private var currentActiveIndex: Int! {
        return coordinators.count - 1
    }

    enum Actions {
        case present
        case replace
        case push
    }

    public static func shared() -> AppCoordinator {
        return instance
    }

    func registerObserverDelegate(delegate: NavigationObserverDelegate, tag: String) {
        delegateArray.updateValue(delegate, forKey: tag)
    }

    func unregisterObserverDelegate(tag: String) {
        delegateArray.removeValue(forKey: tag)
    }

    func backToLogin() {
        if let controller = self.homeViewController {
            controller.goToLogin()
        }
    }

    func isLastControllerType(clazz: AnyClass ) -> Bool {
        if let last = self.coordinators.last {
            return last.getController().isKind(of: clazz)
        } else {
            return false
        }
    }

    func dismissCurrent() {
        self.getCurrentController()?.dismiss(animated: true, completion: nil)
        self.coordinators.removeLast()
    }

    public func containsController(clazz: AnyClass ) -> (Bool, Int) {
        for (index, value) in self.coordinators.enumerated() {
            if value.getController().isKind(of: clazz) {
                return (true, index)
            }
        }
        return (false, -1)
    }

    func indexOf(clazz: AnyClass ) -> (Int) {
        for (index, value) in self.coordinators.enumerated() {
            if value.getController().isKind(of: clazz) {
                return (  index)
            }
        }
        return (-1)
    }

    func getCurrentController() -> UIViewController? {
        return (self.coordinators.last?.getController())
    }

    func getCurrentCoordinator() -> Coordinator {
        return self.coordinators.last!
    }

    func getCoordinator(index: Int) -> Coordinator {
        return self.coordinators[index]
    }

    func getController(index: Int) -> UIViewController {
        return self.coordinators[index].getController()
    }

    func removeNextControllers(index: Int ) {
        for (indexCoord, coordinator) in coordinators.enumerated() where indexCoord >= index {
            self.remove(asChildViewController: coordinator.getController(), container: self.homeViewController.view)
        }
        self.coordinators.removeSubrange(index..<self.coordinators.count)
    }

    func  isStartup() -> Bool {
        return  !(coordinators.count > 1)
    }

    func isLastIndex(index: Int) -> Bool {
        return index == self.coordinators.count - 1
    }

    func initializeCoordinator(homeViewController: HomeViewController) {
        self.coordinators.removeAll()
        self.homeViewController = homeViewController
        self.coordinators.append(Coordinator(controller: self.homeViewController, actionType: .present))
    }

}

extension AppCoordinator: AppCoordinatorProtocol {

    func changeViewController(actionType: AppCoordinator.Actions, controller: UIViewController) {
        let coordinator: Coordinator = Coordinator(controller: controller, actionType: actionType)
        self.changeViewController(coordinator: coordinator)
    }

    func changeViewController(actionType: AppCoordinator.Actions, controller: UIViewController, skipCheck: Bool) {
        let coordinator: Coordinator = Coordinator(controller: controller, actionType: actionType)
        self.changeViewController(coordinator: coordinator, skipCheck: skipCheck)
    }

    func changeViewController(coordinator: Coordinator) {
        self.changeViewController(coordinator: coordinator, skipCheck: false)
    }

    func changeViewController(coordinator: Coordinator, skipCheck: Bool = false) {

        let closure = {
            self.notifyDeselectCtrl()
            switch coordinator.getActionType() {
            case .present:
                break
            case .replace:
                let idx = self.indexOf(clazz: coordinator.getController().classForCoder)
                if idx != -1 {
                    self.removeNextControllers(index: idx)
                }
                self.coordinators.append(coordinator)
            case .push:
                self.coordinators.append(coordinator)
            }
            self.executeChange(coordinator: coordinator)
        }

        if skipCheck {
            closure()
        } else {
            AppCoordinatorNotifier.willBeRemove(controller: self.coordinators.last?.getController()).done {canChange in
                if canChange {
                    closure()
                }
            }.cauterize()
        }
    }

    func changeViewController(index: Int) {
        AppCoordinatorNotifier.willBeRemove(controller: self.coordinators.last?.getController()).done {canChange in
            if canChange {
                self.notifyDeselectCtrl()
                self.executeChange(coordinator: self.coordinators[index])
            }
        }.cauterize()
    }

    private func executeChange(coordinator: Coordinator) {
        switch coordinator.getActionType() {
        case .replace, .push:
            add(asChildViewController: coordinator.getController(), container: homeViewController.mainContainerView)
        case .present:
            presentViewController(withController: coordinator.getController(), animated: true, completion: nil)
        }
    }

    private func changeController() {
        self.notifyDeselectCtrl()
        self.remove(asChildViewController: (self.coordinators.last?.getController())!, container: self.homeViewController.mainContainerView)
        self.coordinators.removeLast()
        let backCoordinator = self.coordinators[self.coordinators.count - 1]
        if let backController = backCoordinator.getController() as? BackController {
            backController.backCalled()
        }
        self.executeChange(coordinator: backCoordinator)
    }

    func back(ignoreCheck: Bool = false) {
        if self.coordinators[currentActiveIndex].getController() as? LoginViewController != nil {
            return
        }
        if self.coordinators[currentActiveIndex].getController() as? HomeViewController != nil {
            return
        }

        if ignoreCheck {
            self.changeController()
        } else {
            AppCoordinatorNotifier.willBeRemove(controller: self.coordinators.last?.getController()).done {(canChange: Bool) in
                if canChange {
                    self.changeController()
                }
            }.cauterize()
        }

    }

}

extension AppCoordinator {
    private func replace(controller: UIViewController, params: [String: Any]) {
        self.changeViewController(actionType: .replace, controller: controller)
    }

    private func present(controller: UIViewController, params: [String: Any]) {
        self.changeViewController(actionType: .present, controller: controller)
    }

    public func presentViewController(withController controller: UIViewController, animated: Bool, homeController: UIViewController? = nil, completion : (() -> Void)?) {
        (homeController ?? homeViewController).present(controller, animated: animated, completion: completion)
    }

    func add(asChildViewController viewController: UIViewController, container: UIView) {

        homeViewController.addChild(viewController)
        container.addSubview(viewController.view)
        viewController.view.frame = container.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self.homeViewController)
        if let currentVC = getCurrentController() {
            self.delegateArray.values.forEach { $0.selectController?(controller: currentVC)}
        }
    }


    func remove(asChildViewController viewController: UIViewController, container: UIView ) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        container.layoutIfNeeded()
        container.layoutSubviews()
    }

    public func notifyDeselectCtrl() {
        guard let lastCtrl  = self.coordinators.last?.getController() else {
            return
        }
        self.delegateArray.values.forEach { $0.deselectController?(controller: lastCtrl)}
    }

}

@objc protocol NavigationObserverDelegate {
    @objc optional func selectController(controller: UIViewController)
    @objc optional func deselectController(controller: UIViewController)
}
