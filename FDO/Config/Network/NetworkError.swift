//
//  NetworkError.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case unknown
    case badRequestInvalidUrl
    case badRequestPathParametersNotFound
    case badRequestEncoding(error: Swift.Error)
    case badDemoModeConfiguration
    case noConnection
    case timeout
    case cancelled
    case missingResponse
    case unauthorized
    case decoding(error: Swift.Error)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown: return "An error occured in service"
        case .badRequestInvalidUrl: return "Bad request invalid url"
        case .badRequestPathParametersNotFound: return "Bad request cannot find parameter in url path"
        case .badRequestEncoding(error: let error): return "Error while encoding request: \(error)"
        case .badDemoModeConfiguration: return "Demo mode configuration malformed"
        case .noConnection: return "There isn't internet connection"
        case .timeout: return "The request timeout"
        case .cancelled: return "The request is cancelled"
        case .missingResponse: return "The request doesn't receive any response"
        case .unauthorized: return "The request receive an unauthorized status code 403"
        case .decoding(error: let error): return "Error while decoding response: \(error)"
        }
    }
}
