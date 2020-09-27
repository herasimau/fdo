//
//  SemesterModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public struct SemesterModel {
    public let id: Int
    public let title: String?
    public let lessons: [LessonModel]
}
