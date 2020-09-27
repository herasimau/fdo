//
//  MailPageItemDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct MailPageItemDTO: Decodable {
    let id: Int
    let type: String?
    let unRead: Int?
    let total: Int?
}
