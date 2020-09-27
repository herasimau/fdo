//
//  MailService.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftSpinner

protocol MailServiceAPI: Service {

    func getMailPagePreview(id: Int, mailType: MailType, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<MailPagePreviewModel>)

    func getMailPage(userId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<MailPageModel>)

}

public class MailService: MailServiceAPI {

    private let mailNetworkRepository: MailNetworkRepositoryAPI = DIContainer.inject()
    private let mailLocalRepository: MailPageLocalRepositoryAPI = DIContainer.inject()

    public func getMailPagePreview(id: Int, mailType: MailType, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<MailPagePreviewModel>) {
        if !force, let mailPagePreview = mailLocalRepository.getPreviewPage(id: String(id)) {
            completion( .success(mailPagePreview) )
        } else {
            if !pullRefresh {
                SwiftSpinner.show("Загрузка...")
            }
            mailNetworkRepository.getMailPagePreview(mailType: mailType).done { response in
                if !pullRefresh {
                    SwiftSpinner.hide()
                }
                let mailPage = MailPagePreviewMapper.dtoToModel(response)
                self.mailLocalRepository.deletePreviewPage(id: String(id))
                self.mailLocalRepository.insertPreviewPage(mailPagePreview: mailPage)
                completion( .success(mailPage) )
            }.catch { error in
                error.handle(completion: completion)
            }
        }
    }

    public func getMailPage(userId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<MailPageModel>) {
        if !force, let mailPage = mailLocalRepository.getPage(id: String(userId)) {
            completion( .success(mailPage) )
        } else {
            if !pullRefresh {
                SwiftSpinner.show("Загрузка...")
            }
            mailNetworkRepository.getMailPage().done { response in
                if !pullRefresh {
                    SwiftSpinner.hide()
                }
                let mailPage = MailPageMapper.dtoToModel(response)
                self.mailLocalRepository.deletePage(id: String(userId))
                self.mailLocalRepository.insertPage(mailPage: mailPage)
                if pullRefresh {
                    mailPage.mailItems.forEach { item in
                        self.mailLocalRepository.deletePreviewPage(id: String(item.id))
                    }
                }
                completion( .success(mailPage) )
            }.catch { error in
                error.handle(completion: completion)
            }
        }
    }

}
