//
//  MailPageMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
//test
struct MailPageMapper: DTODecodableMappable {
    typealias Model = MailPageModel
    typealias Dto = MailPageDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        let mailItems = dto.mailItems.map { MailPageItemMapper.dtoToModel($0) }
        return MailPageModel(id: dto.id, mailItems: mailItems)
    }
}
