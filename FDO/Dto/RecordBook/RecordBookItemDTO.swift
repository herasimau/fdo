//
//  RecordBookItemDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct RecordBookItemDTO: Decodable {
    let id: String?
    let title: String?
    let hours: String?
    let intermediateCertification: String?
    let grade: String?
    let completionDate: Date?
    let teacherName: String?
}
