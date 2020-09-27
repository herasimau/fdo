//
//  UserLocalRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

protocol UserLocalRepositoryAPI: Repository {

    func get(id: String) -> UserInfoModel?

    func insert(user: UserInfoModel)

    func delete(id: String)

}

class UserLocalRepository: NSObject, UserLocalRepositoryAPI {

    public func insert(user: UserInfoModel) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(UserInfoRealmMapper.modelToRealm(user))
        }
    }

    public func get(id: String) -> UserInfoModel? {
        let realm = try! Realm()
        if let user = realm.object(ofType: UserInfoRealm.self, forPrimaryKey: id) {
            return UserInfoRealmMapper.realmToModel(user)
        } else {
            return nil
        }
    }

    public func delete(id: String) {
        let realm = try! Realm()
        let userRealm: UserInfoRealm? = realm.object(ofType: UserInfoRealm.self, forPrimaryKey: id)
        try! realm.write {
            if let user = userRealm {
                realm.delete(user)
            }
        }
    }

}
