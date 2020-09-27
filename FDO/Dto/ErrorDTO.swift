//
//  ErrorDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit

public class ErrorDTO: NSObject, Error {

    public var message: String  = ""

    public init(message: String) {
        self.message = message
    }

}
