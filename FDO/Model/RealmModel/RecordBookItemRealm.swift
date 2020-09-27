//
//  RecordBookItemRealm.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class RecordBookItemRealm: Object {

    dynamic var id: String = ""
    dynamic var title: String?
    dynamic var hours: String?
    dynamic var intermediateCertification: String?
    dynamic var grade: String?
    dynamic var completionDate: Date?
    dynamic var teacherName: String?

    // MARK: - Realm
    override public class func primaryKey() -> String? {
        return "id"
    }
}

