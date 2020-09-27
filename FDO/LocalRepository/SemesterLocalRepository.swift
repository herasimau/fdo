//
//  SemesterLocalRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

protocol SemesterLocalRepositoryAPI: Repository {

    func get(id: String) -> SemesterModel?

    func insert(semester: SemesterModel)

    func delete(id: String)

}

class SemesterLocalRepository: NSObject, SemesterLocalRepositoryAPI {

    public func insert(semester: SemesterModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(SemesterRealmMapper.modelToRealm(semester))
        }
    }

    public func get(id: String) -> SemesterModel? {
        let realm = try! Realm()
        if let semester = realm.object(ofType: SemesterRealm.self, forPrimaryKey: id) {
            return SemesterRealmMapper.realmToModel(semester)
        } else {
            return nil
        }
    }

    public func delete(id: String) {
        let realm = try! Realm()
        let semesterRealm: SemesterRealm? = realm.object(ofType: SemesterRealm.self, forPrimaryKey: id)
        try! realm.write {
            if let semester = semesterRealm {
                realm.delete(semester, cascading: true)
            }
        }
    }

}
