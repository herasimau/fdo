//
//  SemesterNetworkRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit

protocol SemesterNetworkRepositoryAPI: Repository {
 
    func getSemesters() -> Promise<[SemesterBaseDTO]>

    func getSemester(semesterId: Int) -> Promise<SemesterDTO>

}

class SemesterNetworkRepository: SemesterNetworkRepositoryAPI {

    private let networkAdapter: NetworkAdapterAPI = NetworkAdapter.shared
    private let baseUrl: String

    init(host: String) {
        self.baseUrl = host + "semester/"
    }

    func getSemesters() -> Promise<[SemesterBaseDTO]> {
        let request = BaseNetworkRequest(baseUrl: baseUrl, path: "", method: .get)
        return networkAdapter.requestObject(request: request)
    }

    func getSemester(semesterId: Int) -> Promise<SemesterDTO> {
        let request = BaseNetworkRequest(baseUrl: baseUrl, path: ":semesterId", method: .get)
        request.pathParameters = ["semesterId" : semesterId]
        return networkAdapter.requestObject(request: request)
    }

}
