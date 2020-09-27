//
//  CertificationModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 21/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public enum CertificationType: String {
    case test = "TEST"
    case exam = "EXAM"
    case credit = "CREDIT"
    case laboratory = "LABORATORY"
    case none = "NONE"
}

public struct CertificationModel {
    public let id: Int
    public let title: String?
    public let certificationType: CertificationType?
    public let score: String?
    public let completionDate: Date?
    public let teacherName: String?
}
