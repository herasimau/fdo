//
//  RecordBookRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct RecordBookRealmMapper {

    static func modelToRealm(_ model: RecordBookModel) -> RecordBookRealm {
        let recordBook = RecordBookRealm()
        recordBook.id = String(model.id)
        let recordBookItems = List<RecordBookItemRealm>()
        model.recordBookItems.map { RecordBookItemRealmMapper.modelToRealm($0) }.forEach { recordBookItems.append($0) }
        recordBook.recordBookItems.append(objectsIn: recordBookItems)
        return recordBook
    }

    static func realmToModel(_ realm: RecordBookRealm) -> RecordBookModel {
        let recordBookItems = Array(realm.recordBookItems).map { RecordBookItemRealmMapper.realmToModel($0) }
        return RecordBookModel(id: Int(realm.id) ?? -1, recordBookItems: recordBookItems)
    }
}
