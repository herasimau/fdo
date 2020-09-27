//
//  PaymentDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct PaymentDTO: Decodable {
    let id: String?
    let amount: String?
    let paymentDate: Date?
    let purpose: String?
}
