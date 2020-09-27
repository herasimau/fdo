//
//  LessonModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public struct LessonModel {
    public let id: Int
    public let title: String?
    public let certifications: [CertificationModel]
}
