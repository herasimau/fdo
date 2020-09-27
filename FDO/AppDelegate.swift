//
//  AppDelegate.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 14/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.initDependecyInjection()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    private func initDependecyInjection() {
        registerLocalRepository()
        registerNetworkRepository()
        registerService()
    }

    private func registerLocalRepository() {
        DIContainer.register(UserLocalRepositoryAPI.self, component: UserLocalRepository())
        DIContainer.register(SemesterLocalRepositoryAPI.self, component: SemesterLocalRepository())
        DIContainer.register(SemesterBaseLocalRepositoryAPI.self, component: SemesterBaseLocalRepository())
        DIContainer.register(RecordBookLocalRepositoryAPI.self, component: RecordBookLocalRepository())
        DIContainer.register(PaymentLocalRepositoryAPI.self, component: PaymentLocalRepository())
        DIContainer.register(MailPageLocalRepositoryAPI.self, component: MailPageLocalRepository())
    }

    private func registerNetworkRepository() {
        let localhost = "http://64.227.119.8:8080/"
        DIContainer.register(AuthNetworkRepositoryAPI.self, component: AuthNetworkRepository(host: localhost))
        DIContainer.register(UserNetworkRepositoryAPI.self, component: UserNetworkRepository(host: localhost))
        DIContainer.register(SemesterNetworkRepositoryAPI.self, component: SemesterNetworkRepository(host: localhost))
        DIContainer.register(RecordBookNetworkRepositoryAPI.self, component: RecordBookNetworkRepository(host: localhost))
        DIContainer.register(PaymentNetworkRepositoryAPI.self, component: PaymentNetworkRepository(host: localhost))
        DIContainer.register(MailNetworkRepositoryAPI.self, component: MailNetworkRepository(host: localhost))
    }

    private func registerService() {
        DIContainer.register(AuthServiceAPI.self, component: AuthService())
        DIContainer.register(UserServiceAPI.self, component: UserService())
        DIContainer.register(SemesterServiceAPI.self, component: SemesterService())
        DIContainer.register(RecordBookServiceAPI.self, component: RecordBookService())
        DIContainer.register(PaymentServiceAPI.self, component: PaymentService())
        DIContainer.register(MailServiceAPI.self, component: MailService())
    }

}

