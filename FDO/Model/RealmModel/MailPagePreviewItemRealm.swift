//
//  MailPagePreviewItemRealm.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class MailPagePreviewItemRealm: Object {

    dynamic var id: String = ""
    dynamic var unRead: String?
    dynamic var from: String?
    dynamic var subject: String?
    dynamic var date: Date?

    // MARK: - Realm
    override public class func primaryKey() -> String? {
        return "id"
    }
}
