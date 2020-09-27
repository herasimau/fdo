//
//  DateExtension.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

extension Date {
    func toString(style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ru-RU")
        dateFormatter.dateStyle = style
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
}
