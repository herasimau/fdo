//
//  CertificationDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct CertificationDTO: Decodable {
    let id: Int
    let title: String?
    let type: String?
    let score: String?
    let completionDate: Date?
    let teacherName: String?
}
