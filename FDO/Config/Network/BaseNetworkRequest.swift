//
//  BaseNetworkRequest.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import Alamofire

public class BaseNetworkRequest: NetworkCodableRequest {

    public override init(baseUrl: String, path: String, method: HTTPMethod, requestType: RequestType = .data) {
        super.init(baseUrl: baseUrl, path: path, method: method, requestType: requestType)
    }
}
