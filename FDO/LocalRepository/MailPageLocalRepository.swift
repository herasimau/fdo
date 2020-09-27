//
//  MailPageLocalRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

protocol MailPageLocalRepositoryAPI: Repository {

    func getPage(id: String) -> MailPageModel?

    func insertPage(mailPage: MailPageModel)

    func deletePage(id: String)

    func getPreviewPage(id: String) -> MailPagePreviewModel?

    func insertPreviewPage(mailPagePreview: MailPagePreviewModel)

    func deletePreviewPage(id: String)

}

class MailPageLocalRepository: NSObject, MailPageLocalRepositoryAPI {

    public func insertPage(mailPage: MailPageModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(MailPageRealmMapper.modelToRealm(mailPage))
        }
    }

    public func getPage(id: String) -> MailPageModel? {
        let realm = try! Realm()
        if let mailPage = realm.object(ofType: MailPageRealm.self, forPrimaryKey: id) {
            return MailPageRealmMapper.realmToModel(mailPage)
        } else {
            return nil
        }
    }

    public func deletePage(id: String) {
        let realm = try! Realm()
        let mailPage: MailPageRealm? = realm.object(ofType: MailPageRealm.self, forPrimaryKey: id)
        try! realm.write {
            if let page = mailPage {
                realm.delete(page, cascading: true)
            }
        }
    }

    public func insertPreviewPage(mailPagePreview: MailPagePreviewModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(MailPagePreviewRealmMapper.modelToRealm(mailPagePreview))
        }
    }

    public func getPreviewPage(id: String) -> MailPagePreviewModel? {
        let realm = try! Realm()
        if let mailPage = realm.object(ofType: MailPagePreviewRealm.self, forPrimaryKey: id) {
            return MailPagePreviewRealmMapper.realmToModel(mailPage)
        } else {
            return nil
        }
    }

    public func deletePreviewPage(id: String) {
        let realm = try! Realm()
        let mailPage: MailPagePreviewRealm? = realm.object(ofType: MailPagePreviewRealm.self, forPrimaryKey: id)
        try! realm.write {
            if let page = mailPage {
                realm.delete(page, cascading: true)
            }
        }
    }

}
