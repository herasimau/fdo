//
//  MailPagePreviewItemDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct MailPagePreviewItemDTO: Decodable {
    let id: String
    let date: Date?
    let unRead: Bool?
    let from: String?
    let subject: String?
}
