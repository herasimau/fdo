//
//  MailPagePreviewItemRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct MailPagePreviewItemRealmMapper {

    static func modelToRealm(_ model: MailPagePreviewItemModel) -> MailPagePreviewItemRealm {
        let item = MailPagePreviewItemRealm()
        item.id = model.id
        item.unRead = (model.unRead ?? false) ? "true" : "false"
        item.subject = model.subject
        item.from = model.from
        item.date = model.date
        return item
    }

    static func realmToModel(_ realm: MailPagePreviewItemRealm) -> MailPagePreviewItemModel {
        let unRead = realm.unRead == "true" ? true : false
        return MailPagePreviewItemModel(id: realm.id, date: realm.date, unRead: unRead, from: realm.from, subject: realm.subject)
    }
}
