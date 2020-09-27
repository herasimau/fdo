//
//  MailPageItemMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct MailPageItemMapper: DTODecodableMappable {
    typealias Model = MailPageItemModel
    typealias Dto = MailPageItemDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        var typeModel: MailType?
        if let type = dto.type {
            typeModel = MailType(rawValue: type)
        }
        return MailPageItemModel(id: dto.id, type: typeModel, unRead: dto.unRead, total: dto.total)
    }
}
