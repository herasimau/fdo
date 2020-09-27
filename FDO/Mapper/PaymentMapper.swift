//
//  PaymentMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct PaymentMapper: DTODecodableMappable {
    typealias Model = PaymentModel
    typealias Dto = PaymentDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        return PaymentModel(id: dto.id, amount: dto.amount, purpose: dto.purpose, paymentDate: dto.paymentDate)
    }
}
