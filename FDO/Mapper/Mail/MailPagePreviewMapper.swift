//
//  MailPagePreviewMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct MailPagePreviewMapper: DTODecodableMappable {
    typealias Model = MailPagePreviewModel
    typealias Dto = MailPagePreviewDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        let mailPreviewItems = dto.mailPreviewItems.map { MailPagePreviewItemMapper.dtoToModel($0) }
        var typeModel: MailType?
        if let type = dto.mailType {
            typeModel = MailType(rawValue: type)
        }
        return MailPagePreviewModel(id: dto.id, mailType: typeModel, mailPreviewItems: mailPreviewItems)
    }
}
