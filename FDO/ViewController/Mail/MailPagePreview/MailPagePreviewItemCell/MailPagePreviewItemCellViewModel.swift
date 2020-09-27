//
//  MailPagePreviewItemCellViewModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

class MailPagePreviewItemCellViewModel: BaseViewModel<MailPagePreviewItemCell, MailPagePreviewItemModel> {

    let regex: String = "([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\\.[a-zA-Z0-9_-]+)"

    override func bind(view: MailPagePreviewItemCell, model: MailPagePreviewItemModel) {
        var fromString: String?
        if let from = model.from {
            let match = matches(for: regex, in: from)
            if match.count > 0 {
                fromString = match[0]
            }
        }

        view.set(from: fromString ?? "", unRead: model.unRead ?? false, subject: model.subject ?? "", date: (model.date?.toString()) ?? "")
    }
    
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

}
