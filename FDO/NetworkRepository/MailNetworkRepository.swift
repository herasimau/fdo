//
//  MailNetworkRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit

protocol MailNetworkRepositoryAPI: Repository {

    func getMailPagePreview(mailType: MailType) -> Promise<MailPagePreviewDTO>

    func getMailPage() -> Promise<MailPageDTO>

}

class MailNetworkRepository: MailNetworkRepositoryAPI {

    private let networkAdapter: NetworkAdapterAPI = NetworkAdapter.shared
    private let baseUrl: String

    init(host: String) {
        self.baseUrl = host + "mail/"
    }

    func getMailPagePreview(mailType: MailType) -> Promise<MailPagePreviewDTO> {
        let request = BaseNetworkRequest(baseUrl: baseUrl, path: "preview", method: .get)
        request.parameters = ["type": mailType.rawValue]
        return networkAdapter.requestObject(request: request)
    }

    func getMailPage() -> Promise<MailPageDTO> {
        let request = BaseNetworkRequest(baseUrl: baseUrl, path: "", method: .get)
        return networkAdapter.requestObject(request: request)
    }

}
