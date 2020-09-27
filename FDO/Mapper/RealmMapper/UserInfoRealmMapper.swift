//
//  UserInfoRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct UserInfoRealmMapper {

    static func modelToRealm(_ model: UserInfoModel) -> UserInfoRealm {
        let user = UserInfoRealm()
        user.id = String(model.id)
        user.completeName = model.completeName
        user.status = model.status
        user.birthday = model.birthday
        user.education = model.education
        user.address = model.address
        user.email = model.email
        user.department = model.department
        user.trainingDirection = model.trainingDirection
        user.group = model.group
        user.course = model.course
        user.studyPlan = model.studyPlan
        user.variantCode = model.variantCode
        user.curator = model.curator
        user.contract = model.contract
        user.paymentRate = model.paymentRate
        user.studentBook = model.studentBook
        return user
    }

    static func realmToModel(_ realm: UserInfoRealm) -> UserInfoModel {
        return UserInfoModel(id: Int(realm.id) ?? -1, completeName: realm.completeName, status: realm.status, birthday: realm.birthday, education: realm.education, address: realm.address, email: realm.email, department: realm.department, trainingDirection: realm.trainingDirection, group: realm.group, course: realm.course, studyPlan: realm.studyPlan, variantCode: realm.variantCode, curator: realm.curator, contract: realm.contract, paymentRate: realm.paymentRate, studentBook: realm.studentBook)
    }
}
