//
//  SemesterMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct SemesterMapper: DTODecodableMappable {
    typealias Model = SemesterModel
    typealias Dto = SemesterDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        let lessonModels = dto.lessons.map { LessonMapper.dtoToModel($0) }
        return SemesterModel(id: dto.id, title: dto.title, lessons: lessonModels)
    }
}
