//
//  PaymentPageMapper.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct PaymentPageMapper: DTODecodableMappable {
    typealias Model = PaymentPageModel
    typealias Dto = PaymentPageDTO

    static func dtoToModel(_ dto: Dto) -> Model {
        let actualPayments = dto.actualPayments.map { PaymentMapper.dtoToModel($0) }
        let planPaymetns = dto.planPayments.map { PaymentMapper.dtoToModel($0) }
        return PaymentPageModel(id: dto.id, planPayments: planPaymetns, actualPayments: actualPayments)
    }
}
