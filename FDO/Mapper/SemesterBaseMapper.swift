//
//  SemesterBaseMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 22/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct SemesterBaseMapper: DTODecodableMappable {
    typealias Model = SemesterBaseModel
    typealias Dto = SemesterBaseDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        return SemesterBaseModel(id: dto.id, isCurrent: dto.isCurrent, title: dto.title)
    }
}
