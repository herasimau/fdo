//
//  SemesterCollectionViewCellViewModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 22/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

class SemesterCollectionViewCellViewModel: BaseViewModel<SemesterCollectionViewCell, SemesterBaseModel> {

    var isSelected: Bool = false

    override func bind(view: SemesterCollectionViewCell, model: SemesterBaseModel) {
        view.set(title: model.title ?? "", isSelected: isSelected)
    }

}
