//
//  MailPageRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct MailPageRealmMapper {

    static func modelToRealm(_ model: MailPageModel) -> MailPageRealm {
        let mailPage = MailPageRealm()
        mailPage.id = String(model.id)
        let mailItems = List<MailPageItemRealm>()
        model.mailItems.map { MailPageItemRealmMapper.modelToRealm($0) }.forEach { mailItems.append($0) }
        mailPage.mailItems.append(objectsIn: mailItems)
        return mailPage
    }

    static func realmToModel(_ realm: MailPageRealm) -> MailPageModel {
        let mailItems = Array(realm.mailItems).map { MailPageItemRealmMapper.realmToModel($0) }
        return MailPageModel(id: Int(realm.id) ?? -1, mailItems: mailItems)
    }
}
