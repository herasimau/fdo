//
//  RecordBookService.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftSpinner

protocol RecordBookServiceAPI: Service {

    func getRecordBook(userId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<RecordBookModel>)

}

public class RecordBookService: RecordBookServiceAPI {

    private let recordBookNetworkRepository: RecordBookNetworkRepositoryAPI = DIContainer.inject()
    private let recordBookLocalRepository: RecordBookLocalRepositoryAPI = DIContainer.inject()

    public func getRecordBook(userId: Int, force: Bool, pullRefresh: Bool, completion: @escaping CustomCompletion<RecordBookModel>) {
        if !force, let recordBook = recordBookLocalRepository.get(id: String(userId)) {
            completion( .success(recordBook) )
        } else {
            if !pullRefresh {
                SwiftSpinner.show("Загрузка...")
            }
            recordBookNetworkRepository.getRecordBook().done { response in
                if !pullRefresh {
                    SwiftSpinner.hide()
                }
                let recordBook = RecordBookMapper.dtoToModel(response)
                self.recordBookLocalRepository.delete(id: String(userId))
                self.recordBookLocalRepository.insert(recordBook: recordBook)
                completion( .success(recordBook) )
            }.catch { error in
                error.handle(completion: completion)
            }
        }
    }

}
