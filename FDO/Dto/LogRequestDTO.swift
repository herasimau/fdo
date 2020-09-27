//
//  LogRequestDTO.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public class LogRequestDTO: DTO {

    public var parameters: [String: Any] = [:]
    public var response_code: Int?
    public var endpoint: String?
    public var request_body: String?
    public var method: String?

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict["parameters"] = self.parameters
        if let value = self.response_code { dict["response_code"] = value }
        if let value = self.endpoint { dict["endpoint"] = value }
        if let value = self.request_body { dict["request_body"] = value }
        if let value = self.method { dict["method"] = value }
        return dict
    }

}
