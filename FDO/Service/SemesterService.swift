//
//  SemesterService.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftSpinner

protocol SemesterServiceAPI: Service {

    func getSemesters(completion: @escaping CustomCompletion<[SemesterBaseModel]>)

    func getSemester(semesterId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<SemesterModel>)

}

public class SemesterService: SemesterServiceAPI {

    private let semesterNetworkRepository: SemesterNetworkRepositoryAPI = DIContainer.inject()
    private let semesterLocalRepository: SemesterLocalRepositoryAPI = DIContainer.inject()
    private let semesterBaseLocalRepository: SemesterBaseLocalRepositoryAPI = DIContainer.inject()

    public func getSemesters(completion: @escaping CustomCompletion<[SemesterBaseModel]>) {
        let semesters = semesterBaseLocalRepository.getAll()
        if !semesters.isEmpty {
            completion( .success(semesters) )
        } else {
            SwiftSpinner.show("Загрузка...")
            semesterNetworkRepository.getSemesters().done { response in
                SwiftSpinner.hide()
                let semesterModels = response.map { SemesterBaseMapper.dtoToModel($0) }
                self.semesterBaseLocalRepository.deleteAll()
                self.semesterBaseLocalRepository.insert(semesters: semesterModels)
                completion( .success(semesterModels) )
            }.catch { error in
                SwiftSpinner.hide()
                error.handle(completion: completion)
            }
        }
    }

    public func getSemester(semesterId: Int, force: Bool, pullRefresh: Bool = false, completion: @escaping CustomCompletion<SemesterModel>) {
        if !force, let semesterRealm = semesterLocalRepository.get(id: String(semesterId)) {
            completion( .success(semesterRealm) )
        } else {
            if !pullRefresh {
                SwiftSpinner.show("Загрузка...")
            }
            semesterNetworkRepository.getSemester(semesterId: semesterId).done { response in
                if !pullRefresh {
                    SwiftSpinner.hide()
                }
                let semesterModel = SemesterMapper.dtoToModel(response)
                self.semesterLocalRepository.delete(id: String(response.id))
                self.semesterLocalRepository.insert(semester: semesterModel)
                completion( .success(semesterModel) )
            }.catch { error in
                SwiftSpinner.hide()
                error.handle(completion: completion)
            }
        }
    }

}
