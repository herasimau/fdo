//
//  MailPagePreviewModel.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 25/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public struct MailPagePreviewModel {
    public let id: Int
    public let mailType: MailType?
    public let mailPreviewItems: [MailPagePreviewItemModel]
}
