//
//  UserInfoDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct UserInfoDTO: Decodable {
    let id: Int
    let completeName: String?
    let status: String?
    let birthday: Date?
    let education: String?
    let address: String?
    let email: String?
    let department: String?
    let trainingDirection: String?
    let group: String?
    let course: String?
    let studyPlan: String?
    let variantCode: String?
    let curator: String?
    let contract: String?
    let paymentRate: String?
    let studentBook: String?
}

