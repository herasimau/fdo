//
//  CertificationMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct CertificationMapper: DTODecodableMappable {
    typealias Model = CertificationModel
    typealias Dto = CertificationDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        var typeModel: CertificationType?
        if let type = dto.type {
            typeModel = CertificationType(rawValue: type)
        }
        let title = dto.title?.components(separatedBy: "_")
        return CertificationModel(id: dto.id, title: title?[0], certificationType: typeModel, score: dto.score, completionDate: dto.completionDate, teacherName: dto.teacherName)
    }
}
