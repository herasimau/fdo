//
//  MailPageItemCellViewModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

class MailPageItemCellViewModel: BaseViewModel<MailPageItemCell, MailPageItemModel> {

    override func bind(view: MailPageItemCell, model: MailPageItemModel) {
        var title: String = ""
        switch (model.type) {
        case .arrival:
            title = "Входящие"
        case .sent:
            title = "Отправленные"
        case .study:
            title = "Учебная"
        default:
            title =  ""
        }
        view.set(title: title, unRead: model.unRead, total: model.total, mailType: model.type ?? .sent)
    }

}
