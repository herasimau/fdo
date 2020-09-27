//
//  MailPagePreviewItemMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct MailPagePreviewItemMapper: DTODecodableMappable {
    typealias Model = MailPagePreviewItemModel
    typealias Dto = MailPagePreviewItemDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        return MailPagePreviewItemModel(id: dto.id, date: dto.date, unRead: dto.unRead, from: dto.from, subject: dto.subject)
    }
}
