//
//  RecordBookPresenter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import SwiftSpinner

protocol RecordBookPresenterProtocol: class {
    var numOfRecords: Int { get }
    func loadData(force: Bool, pullRefresh: Bool)
    func viewModelForRecordItem(at index: Int) -> BaseViewBindable<RecordBookCell>
}

class RecordBookPresenter: BasePresenter<RecordBookViewController, Void>, RecordBookPresenterProtocol {
    private let recordBookService: RecordBookServiceAPI = DIContainer.inject()

    private var recordItems: [RecordBookCellViewModel] = []
    private var recordBook: RecordBookModel?

    var numOfRecords: Int {
        return recordItems.count
    }

    func viewModelForRecordItem(at index: Int) -> BaseViewBindable<RecordBookCell> {
        return recordItems[index]
    }

    func loadData(force: Bool, pullRefresh: Bool) {
        getRecordBook(force: force, pullRefresh: pullRefresh)
    }

    public func getRecordBook(force: Bool, pullRefresh: Bool = false) {
        recordBookService.getRecordBook(userId: AuthManager.shared.getAuth()?.userId ?? -1, force: force, pullRefresh: pullRefresh) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let recordBook):
                self.recordBook = recordBook
                self.recordItems = recordBook.recordBookItems.map { RecordBookCellViewModel(model: $0) }
                self.view?.reloadTable(pullRefresh: pullRefresh)
            case .failure:
                print("Error loading RecordBook")
            }
        }
    }

}
