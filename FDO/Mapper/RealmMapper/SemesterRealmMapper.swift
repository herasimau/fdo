//
//  SemesterRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct SemesterRealmMapper {

    static func modelToRealm(_ model: SemesterModel) -> SemesterRealm {
        let semester = SemesterRealm()
        semester.id = String(model.id)
        semester.title = model.title
        let lessons = List<LessonRealm>()
        model.lessons.map { LessonRealmMapper.modelToRealm($0) }.forEach { lessons.append($0) }
        semester.lessons.append(objectsIn: lessons)
        return semester
    }

    static func realmToModel(_ realm: SemesterRealm) -> SemesterModel {
        let lessons = Array(realm.lessons).map { LessonRealmMapper.realmToModel($0) }
        return SemesterModel(id: Int(realm.id) ?? -1, title: realm.title, lessons: lessons)
    }
}
