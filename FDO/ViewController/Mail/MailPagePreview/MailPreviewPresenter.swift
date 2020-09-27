//
//  MailPreviewPresenter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 26/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import SwiftSpinner

protocol MailPreviewPresenterProtocol: class {
    var id: Int? { get set }
    var mailType: MailType? { get set }
    var numOfMailPreviewItems: Int { get }
    func loadData(force: Bool, pullRefresh: Bool)
    func viewModelForMailPagePreviewItem(at index: Int) -> BaseViewBindable<MailPagePreviewItemCell>
    func getMailPreviewController() -> UIViewController
}

class MailPreviewPresenter: BasePresenter<MailPagePreviewViewController, Void>, MailPreviewPresenterProtocol {
    private let mailService: MailServiceAPI = DIContainer.inject()

    private var mailPreviewItems: [MailPagePreviewItemCellViewModel] = []
    private var mailPagePreview: MailPagePreviewModel?
    var id: Int?
    var mailType: MailType?

    var numOfMailPreviewItems: Int {
       return mailPreviewItems.count
    }

    func viewModelForMailPagePreviewItem(at index: Int) -> BaseViewBindable<MailPagePreviewItemCell> {
       return mailPreviewItems[index]
    }

    func loadData(force: Bool, pullRefresh: Bool) {
        getMailPage(force: force, pullRefresh: pullRefresh)
    }

    func getMailPreviewController() -> UIViewController {
        let mailPreviewViewController = self.start()
        var title: String?
        switch mailType {
        case .arrival:
            title = "Входящие"
        case .sent:
            title = "Отправленные"
        case .study:
            title = "Учебная"
        default:
            break
        }
        mailPreviewViewController.title = title
        return mailPreviewViewController
    }

    public func getMailPage(force: Bool, pullRefresh: Bool = false) {
        mailService.getMailPagePreview(id: self.id ?? -1, mailType: self.mailType ?? .sent, force: force, pullRefresh: pullRefresh) { [weak self] result in
           guard let self = self else { return }
           switch result {
           case .success(let mailPage):
               self.mailPagePreview = mailPage
               self.mailPreviewItems = mailPage.mailPreviewItems.map { MailPagePreviewItemCellViewModel(model: $0) }
               self.view?.reloadTable(pullRefresh: pullRefresh)
           case .failure:
               print("Error loading RecordBook")
           }
       }
    }

}
