//
//  SemesterBaseLocalRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 22/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

protocol SemesterBaseLocalRepositoryAPI: Repository {

    func getAll() -> [SemesterBaseModel]

    func insert(semesters: [SemesterBaseModel])

    func deleteAll()

}

class SemesterBaseLocalRepository: NSObject, SemesterBaseLocalRepositoryAPI {

    public func insert(semesters: [SemesterBaseModel]) {
        let realm = try! Realm()
        semesters.forEach { s in
            try! realm.write {
                realm.add(SemesterBaseRealmMapper.modelToRealm(s))
            }
        }
    }

    public func getAll() -> [SemesterBaseModel] {
        let realm = try! Realm()
        return Array(realm.objects(SemesterBaseRealm.self)).map { SemesterBaseRealmMapper.realmToModel($0) }
    }

    public func deleteAll() {
        let realm = try! Realm()
        realm.objects(SemesterBaseRealm.self).forEach { s in
            try! realm.write {
                realm.delete(s)
            }
        }
    }

}
