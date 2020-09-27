//
//  RecordBookLocalRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

protocol RecordBookLocalRepositoryAPI: Repository {

    func get(id: String) -> RecordBookModel?

    func insert(recordBook: RecordBookModel)

    func delete(id: String)

}

class RecordBookLocalRepository: NSObject, RecordBookLocalRepositoryAPI {

    public func insert(recordBook: RecordBookModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(RecordBookRealmMapper.modelToRealm(recordBook))
        }
    }

    public func get(id: String) -> RecordBookModel? {
        let realm = try! Realm()
        if let recordBook = realm.object(ofType: RecordBookRealm.self, forPrimaryKey: id) {
            return RecordBookRealmMapper.realmToModel(recordBook)
        } else {
            return nil
        }
    }

    public func delete(id: String) {
        let realm = try! Realm()
        let recordBook: RecordBookRealm? = realm.object(ofType: RecordBookRealm.self, forPrimaryKey: id)
        try! realm.write {
            if let book = recordBook {
                realm.delete(book, cascading: true)
            }
        }
    }

}
