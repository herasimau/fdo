//
//  SemesterBaseDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 22/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct SemesterBaseDTO: Decodable {
    let id: Int
    let isCurrent: Bool
    let title: String?
}
