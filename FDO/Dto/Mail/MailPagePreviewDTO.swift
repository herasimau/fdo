//
//  MailPagePreviewDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct MailPagePreviewDTO: Decodable {
    let id: Int
    let mailType: String?
    let mailPreviewItems: [MailPagePreviewItemDTO]
}
