//
//  NetworkRequest.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Alamofire

public class NetworkRequest: NSObject {

    public var url: String!
    public var method: HTTPMethod!
    public var parameters: Parameters?
    public var encoding: ParameterEncoding?
    public var headers: HTTPHeaders?
    public var authorizationRequired: Bool!
    public var downloadDestination: DownloadRequest.DownloadFileDestination?
    public var progressHandler: DownloadRequest.ProgressHandler?

    public init(url: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding? = nil, headers: HTTPHeaders? = nil, authorizationRequired: Bool = true, downloadDestination: DownloadRequest.DownloadFileDestination? = nil, progressHandler: DownloadRequest.ProgressHandler? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
        self.authorizationRequired = authorizationRequired
        self.downloadDestination = downloadDestination
        self.progressHandler = progressHandler
    }
}
