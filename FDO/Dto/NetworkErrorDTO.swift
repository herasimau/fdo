//
//  NetworkErrorDTO.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import ObjectMapper

public class NetworkErrorDTO: NSObject, Error, Mappable {

    public var status: Int?
    public var request: LogRequestDTO?

    public required override init () {}

    required convenience public init?(map: Map) {
        self.init()
    }

    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public func mapping(map: Map) {
        status <- map["status"]
    }

}
