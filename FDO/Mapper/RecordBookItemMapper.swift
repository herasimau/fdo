//
//  RecordBookItemMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct RecordBookItemMapper: DTODecodableMappable {
    typealias Model = RecordBookItemModel
    typealias Dto = RecordBookItemDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        return RecordBookItemModel(id: dto.id, title: dto.title, hours: dto.hours, intermediateCertification: dto.intermediateCertification, grade: dto.grade, completionDate: dto.completionDate, teacherName: dto.teacherName)
    }
}
