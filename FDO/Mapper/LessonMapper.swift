//
//  LessonMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct LessonMapper: DTODecodableMappable {
    typealias Model = LessonModel
    typealias Dto = LessonDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        let certificationModels = dto.certifications.map { CertificationMapper.dtoToModel($0) }
        let title = dto.title?.components(separatedBy: "_")
        return LessonModel(id: dto.id, title: title?[0], certifications: certificationModels)
    }
}
