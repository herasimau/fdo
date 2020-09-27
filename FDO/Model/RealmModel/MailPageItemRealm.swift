//
//  MailPageItemRealm.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class MailPageItemRealm: Object {

    dynamic var id: String = ""
    dynamic var unRead: String?
    dynamic var total: String?
    dynamic var type: String?

    // MARK: - Realm
    override public class func primaryKey() -> String? {
        return "id"
    }
}
