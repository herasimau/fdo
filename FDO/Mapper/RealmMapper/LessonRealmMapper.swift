//
//  LessonRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct LessonRealmMapper {

    static func modelToRealm(_ model: LessonModel) -> LessonRealm {
        let lesson = LessonRealm()
        lesson.id = String(model.id)
        lesson.title = model.title
        let certifications = List<CertificationRealm>()
        model.certifications.map { CertificationRealmMapper.modelToRealm($0) }.forEach { certifications.append($0) }
        lesson.certifications.append(objectsIn: certifications)
        return lesson
    }

    static func realmToModel(_ realm: LessonRealm) -> LessonModel {
        let certifications = Array(realm.certifications).map { CertificationRealmMapper.realmToModel($0) }
        return LessonModel(id: Int(realm.id) ?? -1, title: realm.title, certifications: certifications)
    }
}
