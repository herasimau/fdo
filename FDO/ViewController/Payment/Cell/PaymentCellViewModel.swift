//
//  PaymentCellViewModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

class PaymentCellViewModel: BaseViewModel<PaymentCell, PaymentModel> {

    override func bind(view: PaymentCell, model: PaymentModel) {
        view.set(purpose: model.purpose ?? "", amount: model.amount ?? "", paymentDate: (model.paymentDate?.toString()) ?? "")
    }

}
