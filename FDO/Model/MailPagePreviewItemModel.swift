//
//  MailPagePreviewItemModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public struct MailPagePreviewItemModel {
    public let id: String
    public let date: Date?
    public let unRead: Bool?
    public let from: String?
    public let subject: String?
}
