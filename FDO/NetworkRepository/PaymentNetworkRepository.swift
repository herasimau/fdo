//
//  PaymentNetworkRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit

protocol PaymentNetworkRepositoryAPI: Repository {
 
    func getPayments() -> Promise<PaymentPageDTO>

}

class PaymentNetworkRepository: PaymentNetworkRepositoryAPI {

    private let networkAdapter: NetworkAdapterAPI = NetworkAdapter.shared
    private let baseUrl: String

    init(host: String) {
        self.baseUrl = host + "payments/"
    }

    func getPayments() -> Promise<PaymentPageDTO> {
        let request = BaseNetworkRequest(baseUrl: baseUrl, path: "", method: .get)
        return networkAdapter.requestObject(request: request)
    }

}
