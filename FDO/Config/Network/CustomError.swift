//
//  CustomError.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public enum CustomError: Error {
    case unknown
    case badRequest
    case cancelled
    case noConnection
    case timeout
    case missingResponse
    case unauthorized
    case decoding
    case simple(text: String)

    init(networkError: NetworkError) {
        switch networkError {
        case .unknown:
            self = .unknown
        case .badRequestInvalidUrl,
             .badRequestPathParametersNotFound,
             .badRequestEncoding,
             .badDemoModeConfiguration:
            self = .badRequest
        case .noConnection:
            self = .noConnection
        case .timeout:
            self = .timeout
        case .missingResponse:
            self = .missingResponse
        case .unauthorized:
            self = .unauthorized
        case .decoding:
            self = .decoding
        case .cancelled:
            self = .cancelled
        }
    }
}

// Rest error model
public struct RestErrorModel {
    public let status: Int
    public let message: String
    public let error: String
    public let exception: String
}
