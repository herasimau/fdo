//
//  LessonRealm.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class LessonRealm: Object {

    dynamic var id: String = ""
    dynamic var title: String?
    let certifications =  List<CertificationRealm>()

    // MARK: - Realm
    override public class func primaryKey() -> String? {
        return "id"
    }
}
