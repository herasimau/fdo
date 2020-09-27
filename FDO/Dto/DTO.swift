//
//  DTO.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import ObjectMapper

open class DTO: NSObject, Mappable {

    public required override init () {}

    required convenience public init?(map: Map) {
        self.init()
    }

    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    open func mapping(map: Map) {}

    open func toDict() -> [String: Any] {
        return [:]
    }
}
