//
//  RecordBookRealm.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class RecordBookRealm: Object {

    dynamic var id: String = ""
    let recordBookItems = List<RecordBookItemRealm>()

    // MARK: - Realm
    override public class func primaryKey() -> String? {
        return "id"
    }
}
