//
//  MailPageItemModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public enum MailType: String {
    case arrival = "ARRIVAL"
    case sent = "SENT"
    case study = "STUDY"
}

public struct MailPageItemModel {
    public let id: Int
    public let type: MailType?
    public let unRead: Int?
    public let total: Int?
}
