//
//  RecordBookCellViewModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

class RecordBookCellViewModel: BaseViewModel<RecordBookCell, RecordBookItemModel> {

    override func bind(view: RecordBookCell, model: RecordBookItemModel) {
        view.set(title: model.title, grade: model.grade, intermidiateCertification: model.intermediateCertification, date: model.completionDate?.toString())
    }

}
