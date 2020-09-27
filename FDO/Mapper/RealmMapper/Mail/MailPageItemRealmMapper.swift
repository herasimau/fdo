//
//  MailPageItemRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct MailPageItemRealmMapper {

    static func modelToRealm(_ model: MailPageItemModel) -> MailPageItemRealm {
        let item = MailPageItemRealm()
        item.id = String(model.id)
        item.unRead = String(model.unRead ?? 0)
        item.total = String(model.total ?? 0)
        item.type = model.type?.rawValue
        return item
    }

    static func realmToModel(_ realm: MailPageItemRealm) -> MailPageItemModel {
        var typeModel: MailType?
        if let type = realm.type {
            typeModel = MailType(rawValue: type)
        }
        return MailPageItemModel(id: Int(realm.id) ?? -1, type: typeModel, unRead: Int(realm.unRead ?? "0"), total: Int(realm.total ?? "0"))
    }
}
