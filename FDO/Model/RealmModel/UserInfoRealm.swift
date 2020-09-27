//
//  UserInfoRealm.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class UserInfoRealm: Object {

    dynamic var id: String = ""
    dynamic var completeName: String?
    dynamic var status: String?
    dynamic var birthday: Date?
    dynamic var education: String?
    dynamic var address: String?
    dynamic var email: String?
    dynamic var department: String?
    dynamic var trainingDirection: String?
    dynamic var group: String?
    dynamic var course: String?
    dynamic var studyPlan: String?
    dynamic var variantCode: String?
    dynamic var curator: String?
    dynamic var contract: String?
    dynamic var paymentRate: String?
    dynamic var studentBook: String?

    // MARK: - Realm
    override public class func primaryKey() -> String? {
        return "id"
    }
}
