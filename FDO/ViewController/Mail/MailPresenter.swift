//
//  MailPresenter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import SwiftSpinner

protocol MailPresenterProtocol: class {
    var numOfMailItems: Int { get }
    func openMailPreviewController(at index: Int)
    func loadData(force: Bool, pullRefresh: Bool)
    func viewModelForMailPageItem(at index: Int) -> BaseViewBindable<MailPageItemCell>
    func getMailController() -> UIViewController
}

class MailPresenter: BasePresenter<MailViewController, Void>, MailPresenterProtocol {
    private let mailService: MailServiceAPI = DIContainer.inject()

    private var mailItems: [MailPageItemCellViewModel] = []
    private var mailPage: MailPageModel?
    var navigationController: UINavigationController?

    var numOfMailItems: Int {
       return mailItems.count
    }

    func viewModelForMailPageItem(at index: Int) -> BaseViewBindable<MailPageItemCell> {
       return mailItems[index]
    }

    func loadData(force: Bool, pullRefresh: Bool) {
       getMailPage(force: force, pullRefresh: pullRefresh)
    }

    func openMailPreviewController(at index: Int) {
        let viewModel = mailItems[index]
        let presenter = MailPreviewPresenter()
        presenter.id = viewModel.model.id
        presenter.mailType = viewModel.model.type ?? .sent
        let controller = presenter.getMailPreviewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    func getMailController() -> UIViewController {
        let mailViewController = self.start()
        mailViewController.title = "Почта"
        navigationController = UINavigationController(rootViewController: mailViewController)
        navigationController?.navigationBar.tintColor = UIColor(named: "logoColor")
        return navigationController ?? UINavigationController()
    }

    public func getMailPage(force: Bool, pullRefresh: Bool = false) {
       mailService.getMailPage(userId: AuthManager.shared.getAuth()?.userId ?? -1, force: force, pullRefresh: pullRefresh) { [weak self] result in
           guard let self = self else { return }
           switch result {
           case .success(let mailPage):
               self.mailPage = mailPage
               self.mailItems = mailPage.mailItems.map { MailPageItemCellViewModel(model: $0) }
               self.view?.reloadTable(pullRefresh: pullRefresh)
           case .failure:
               print("Error loading RecordBook")
           }
       }
    }

}
