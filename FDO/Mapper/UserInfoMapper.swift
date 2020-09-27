//
//  UserInfoMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct UserInfoMapper: DTODecodableMappable {
    typealias Model = UserInfoModel
    typealias Dto = UserInfoDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        return UserInfoModel(id: dto.id, completeName: dto.completeName, status: dto.status, birthday: dto.birthday, education: dto.education, address: dto.address, email: "hidden@study.tusur.ru", department: dto.department, trainingDirection: dto.trainingDirection, group: "а-404П2-1", course: dto.course, studyPlan: dto.studyPlan, variantCode: dto.variantCode, curator: dto.curator, contract: dto.contract, paymentRate: dto.paymentRate, studentBook: dto.studentBook)
    }
}
