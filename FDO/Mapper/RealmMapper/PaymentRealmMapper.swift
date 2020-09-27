//
//  PaymentRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct PaymentRealmMapper {

    static func modelToRealm(_ model: PaymentModel) -> PaymentRealm {
        let payment = PaymentRealm()
        payment.id = model.id ?? ""
        payment.amount = model.amount
        payment.purpose = model.purpose
        payment.paymentDate = model.paymentDate
        return payment
    }

    static func realmToModel(_ realm: PaymentRealm) -> PaymentModel {
        return PaymentModel(id: realm.id, amount: realm.amount, purpose: realm.purpose, paymentDate: realm.paymentDate)
    }
}
