//
//  PaymentRealm.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class PaymentRealm: Object {

    dynamic var id: String = ""
    dynamic var amount: String?
    dynamic var purpose: String?
    dynamic var paymentDate: Date?

    // MARK: - Realm
    override public class func primaryKey() -> String? {
        return "id"
    }
}
