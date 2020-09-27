//
//  CertificationRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct CertificationRealmMapper {

    static func modelToRealm(_ model: CertificationModel) -> CertificationRealm {
        let certification = CertificationRealm()
        certification.id = String(model.id)
        certification.title = model.title
        certification.type = model.certificationType?.rawValue
        certification.score = model.score
        certification.teacherName = model.teacherName
        certification.completionDate = model.completionDate
        return certification
    }

    static func realmToModel(_ realm: CertificationRealm) -> CertificationModel {
        let type: CertificationType? = CertificationType(rawValue: realm.type ?? "NONE")
        return CertificationModel(id: Int(realm.id) ?? -1, title: realm.title, certificationType: type, score: realm.score, completionDate: realm.completionDate, teacherName: realm.teacherName)
    }
}
