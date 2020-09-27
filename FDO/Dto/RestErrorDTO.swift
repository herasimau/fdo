//
//  RestErrorDTO.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import ObjectMapper

public class RestErrorDTO: NetworkErrorDTO {

    public var message: String?
    public var error: String?
    public var exception: String?

    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public override func mapping(map: Map) {
        super.mapping(map: map)
        error <- map["error"]
        exception <- map["exception"]
        message <- map["message"]
    }

    public override var description: String {
        var msg = "\tRestErrorDTO {\n"
        if let mes = self.message {
            msg += "\tmessage: \(mes)\n"
        }
        if let err = self.error {
            msg += "\terror: \(err)\n"
        }
        if let exc = self.exception {
            msg += "\texception: \(exc)\n"
        }
        if let sta = self.status {
            msg += "\tstatus: \(sta)\n"
        }
        msg += "}"
        return msg
    }
}
