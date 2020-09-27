//
//  RecordBookMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct RecordBookMapper: DTODecodableMappable {
    typealias Model = RecordBookModel
    typealias Dto = RecordBookDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        let recordBookItems = dto.recordBookItems.map { RecordBookItemMapper.dtoToModel($0) }
        return RecordBookModel(id: dto.id, recordBookItems: recordBookItems)
    }
}
