//
//  SemesterBaseRealm.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 22/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class SemesterBaseRealm: Object {

    dynamic var id: String = ""
    dynamic var isCurrent: Bool = false
    dynamic var title: String?

    // MARK: - Realm
    override public class func primaryKey() -> String? {
        return "id"
    }
}
