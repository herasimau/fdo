//
//  PaymentService.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftSpinner

protocol PaymentServiceAPI: Service {

    func getPayments(userId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<PaymentPageModel>)

}

public class PaymentService: PaymentServiceAPI {

    private let paymentNetworkRepository: PaymentNetworkRepositoryAPI = DIContainer.inject()
    private let paymentLocalRepository: PaymentLocalRepositoryAPI = DIContainer.inject()

    public func getPayments(userId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<PaymentPageModel>) {
        if !force, let payment = paymentLocalRepository.get(id: String(userId)) {
            completion( .success(payment) )
        } else {
            if !pullRefresh {
                SwiftSpinner.show("Загрузка...")
            }
            paymentNetworkRepository.getPayments().done { response in
                if !pullRefresh {
                    SwiftSpinner.hide()
                }
                let paymentPage = PaymentPageMapper.dtoToModel(response)
                self.paymentLocalRepository.delete(id: String(userId))
                self.paymentLocalRepository.insert(paymentPage: paymentPage)
                completion( .success(paymentPage) )
            }.catch { error in
                error.handle(completion: completion)
            }
        }
    }

}
