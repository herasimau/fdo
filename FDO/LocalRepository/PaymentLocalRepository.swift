//
//  PaymentLocalRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

protocol PaymentLocalRepositoryAPI: Repository {

    func get(id: String) -> PaymentPageModel?

    func insert(paymentPage: PaymentPageModel)

    func delete(id: String)

}

class PaymentLocalRepository: NSObject, PaymentLocalRepositoryAPI {

    public func insert(paymentPage: PaymentPageModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(PaymentPageRealmMapper.modelToRealm(paymentPage))
        }
    }

    public func get(id: String) -> PaymentPageModel? {
        let realm = try! Realm()
        if let payment = realm.object(ofType: PaymentPageRealm.self, forPrimaryKey: id) {
            return PaymentPageRealmMapper.realmToModel(payment)
        } else {
            return nil
        }
    }

    public func delete(id: String) {
        let realm = try! Realm()
        let paymentRealm: PaymentPageRealm? = realm.object(ofType: PaymentPageRealm.self, forPrimaryKey: id)
        try! realm.write {
            if let payment = paymentRealm {
                realm.delete(payment, cascading: true)
            }
        }
    }

}
