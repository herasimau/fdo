//
//  MailPagePreviewRealmMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import RealmSwift

struct MailPagePreviewRealmMapper {

    static func modelToRealm(_ model: MailPagePreviewModel) -> MailPagePreviewRealm {
        let mailPagePreview = MailPagePreviewRealm()
        mailPagePreview.id = String(model.id)
        mailPagePreview.mailType = model.mailType?.rawValue
        let mailPreviewItems = List<MailPagePreviewItemRealm>()
        model.mailPreviewItems.map { MailPagePreviewItemRealmMapper.modelToRealm($0) }.forEach { mailPreviewItems.append($0) }
        mailPagePreview.mailPreviewItems.append(objectsIn: mailPreviewItems)
        return mailPagePreview
    }

    static func realmToModel(_ realm: MailPagePreviewRealm) -> MailPagePreviewModel {
        let mailPreviewItems = Array(realm.mailPreviewItems).map { MailPagePreviewItemRealmMapper.realmToModel($0) }
        var typeModel: MailType?
        if let type = realm.mailType {
            typeModel = MailType(rawValue: type)
        }
        return MailPagePreviewModel(id: Int(realm.id) ?? -1, mailType: typeModel, mailPreviewItems: mailPreviewItems)
    }
}
