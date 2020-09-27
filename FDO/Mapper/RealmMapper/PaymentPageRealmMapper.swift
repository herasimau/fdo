//
//  PaymentPageRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct PaymentPageRealmMapper {

    static func modelToRealm(_ model: PaymentPageModel) -> PaymentPageRealm {
        let paymentPage = PaymentPageRealm()
        paymentPage.id = String(model.id)
        let actualPayments = List<PaymentRealm>()
        model.actualPayments.map { PaymentRealmMapper.modelToRealm($0) }.forEach { actualPayments.append($0) }
        paymentPage.actualPayments.append(objectsIn: actualPayments)
        let planPayments = List<PaymentRealm>()
        model.planPayments.map { PaymentRealmMapper.modelToRealm($0) }.forEach { planPayments.append($0) }
        paymentPage.planPayments.append(objectsIn: planPayments)
        return paymentPage
    }

    static func realmToModel(_ realm: PaymentPageRealm) -> PaymentPageModel {
        let actualPayments = Array(realm.actualPayments).map { PaymentRealmMapper.realmToModel($0) }
        let planPayments = Array(realm.planPayments).map { PaymentRealmMapper.realmToModel($0) }

        return PaymentPageModel(id: Int(realm.id) ?? -1, planPayments: planPayments, actualPayments: actualPayments)
    }
}
