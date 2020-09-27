//
//  RecordBookItemRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct RecordBookItemRealmMapper {

    static func modelToRealm(_ model: RecordBookItemModel) -> RecordBookItemRealm {
        let item = RecordBookItemRealm()
        item.id = model.id ?? ""
        item.title = model.title
        item.hours = model.hours
        item.intermediateCertification = model.intermediateCertification
        item.grade = model.grade
        item.teacherName = model.teacherName
        item.completionDate = model.completionDate
        return item
    }

    static func realmToModel(_ realm: RecordBookItemRealm) -> RecordBookItemModel {
        return RecordBookItemModel(id: realm.id, title: realm.title, hours: realm.hours, intermediateCertification: realm.intermediateCertification, grade: realm.grade, completionDate: realm.completionDate, teacherName: realm.teacherName)
    }
}
