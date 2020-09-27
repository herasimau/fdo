//
//  RecordBookNetworkRepository.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit

protocol RecordBookNetworkRepositoryAPI: Repository {
 
    func getRecordBook() -> Promise<RecordBookDTO>

}

class RecordBookNetworkRepository: RecordBookNetworkRepositoryAPI {

    private let networkAdapter: NetworkAdapterAPI = NetworkAdapter.shared
    private let baseUrl: String

    init(host: String) {
        self.baseUrl = host + "record-book/"
    }

    func getRecordBook() -> Promise<RecordBookDTO> {
        let request = BaseNetworkRequest(baseUrl: baseUrl, path: "", method: .get)
        return networkAdapter.requestObject(request: request)
    }

}
