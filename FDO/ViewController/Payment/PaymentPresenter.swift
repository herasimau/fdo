//
//  PaymentPresenter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import SwiftSpinner

protocol PaymentPresenterProtocol: class {
    var numOfActualPayments: Int { get }
    var numOfPlanPayments: Int { get }
    func loadData(force: Bool, pullRefresh: Bool)
    func viewModelForActualPayment(at index: Int) -> BaseViewBindable<PaymentCell>
    func viewModelForPlanPayment(at index: Int) -> BaseViewBindable<PaymentCell>
}

class PaymentPresenter: BasePresenter<PaymentViewController, Void>, PaymentPresenterProtocol {
    private let paymentService: PaymentServiceAPI = DIContainer.inject()

    private var actualPayments: [PaymentCellViewModel] = []
    private var planPayments: [PaymentCellViewModel] = []
    private var paymentPage: PaymentPageModel?

    var numOfActualPayments: Int {
        return actualPayments.count
    }

    var numOfPlanPayments: Int {
        return planPayments.count
    }

    func viewModelForActualPayment(at index: Int) -> BaseViewBindable<PaymentCell> {
        return actualPayments[index]
    }

    func viewModelForPlanPayment(at index: Int) -> BaseViewBindable<PaymentCell> {
        return planPayments[index]
    }

    func loadData(force: Bool, pullRefresh: Bool) {
        getPaymentPage(force: force, pullRefresh: pullRefresh)
    }

    public func getPaymentPage(force: Bool, pullRefresh: Bool = false) {
        paymentService.getPayments(userId: AuthManager.shared.getAuth()?.userId ?? -1, force: force, pullRefresh: pullRefresh) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let payment):
                self.paymentPage = payment
                self.actualPayments = payment.actualPayments.map { PaymentCellViewModel(model: $0) }
                self.planPayments = payment.planPayments.map { PaymentCellViewModel(model: $0) }

                self.view?.reloadTable(pullRefresh: pullRefresh)
            case .failure:
                print("Error loading payments")
            }
        }
    }

}
