//
//  SemesterBaseRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 22/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct SemesterBaseRealmMapper {

    static func modelToRealm(_ model: SemesterBaseModel) -> SemesterBaseRealm {
        let semester = SemesterBaseRealm()
        semester.id = String(model.id)
        semester.isCurrent = model.isCurrent
        semester.title = model.title
        return semester
    }

    static func realmToModel(_ realm: SemesterBaseRealm) -> SemesterBaseModel {
        return SemesterBaseModel(id: Int(realm.id) ?? -1, isCurrent: realm.isCurrent, title: realm.title)
    }
}
