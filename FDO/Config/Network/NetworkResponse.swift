//
//  NetworkResponse.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public protocol NetworkResponse {
    var request: URLRequest? { get }
    var response: HTTPURLResponse? { get }
    var statusCode: Int { get }
    var data: Data? { get }
    var error: Error? { get }
    var isDemo: Bool { get }

    init(request: URLRequest?, response: HTTPURLResponse?, statusCode: Int?, data: Data?, error: Error?)
    init(request: URLRequest?, response: HTTPURLResponse?, statusCode: Int?, data: Data?, error: Error?, isDemo: Bool)

    func decode<T: Decodable>() -> Result<T, NetworkError>
    func decodeError() -> NetworkError
}

public class BaseNetworkResponse: NetworkResponse {

    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let statusCode: Int
    public let data: Data?
    public let error: Error?
    public let isDemo: Bool

    public required convenience init(request: URLRequest?, response: HTTPURLResponse?, statusCode: Int?, data: Data?, error: Error?) {
        self.init(request: request, response: response, statusCode: statusCode, data: data, error: error, isDemo: false)
    }
    public required init(request: URLRequest?, response: HTTPURLResponse?, statusCode: Int?, data: Data?, error: Error?, isDemo: Bool) {
        self.request = request
        self.response = response
        self.statusCode = statusCode ?? 0
        self.data = data
        self.error = error
        self.isDemo = isDemo
    }

    public func decode<T>() -> Result<T, NetworkError> where T: Decodable {
        do {
            guard let data = data else { return .failure(.missingResponse) }
            let decodedObject = try jsonDecoder.decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(.decoding(error: error))
        }
    }

    public func decodeError() -> NetworkError {
        // service errors: mapped to different responses
        return .unknown
    }

    open var jsonDecoder: JSONDecoder {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.custom({ decoder -> Date in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)

        var date: Date?
        for dateFormatter in self.decoderDateFormatters {
          if let dateFromString = dateFormatter.date(from: dateStr) {
            date = dateFromString
            break
          }
        }
        guard date != nil else {
          throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateStr)")
        }
        return date!
      })
      return decoder
    }

    open var decoderDateFormatters: [DateFormatter] {
        return [DateFormatter.serverDateFormatter, DateFormatter.serverDateTimeFormatter, DateFormatter.serverDateTimeTimestampFormatter]
    }
}

// MARK: Print utils
public extension NetworkResponse {

    var description: String {
        let requestUrl = self.request?.url?.absoluteString ?? "UNKNOWN REQUEST URL"
        var desc = ""
        if let resp = self.response {
            desc.append("RESPONSE URL= \(requestUrl)")
            desc.append("\nSTATUS CODE: \(resp.statusCode)\nHEADERS: \(resp.allHeaderFields as? [String: String])")
            if let data = data, !data.isEmpty, let body = String(data: data, encoding: .utf8) {
                desc.append("\nBODY=\n\(body)")
            }
        } else {
            desc.append("RESPONSE NOT RECEIVED - URL= \(requestUrl)")
        }
        return desc
    }

    func errorDescriptionFor(error: NetworkError) -> String {
        var requestUrl: String = ""
        if let url = self.request?.url?.absoluteString {
            requestUrl = "URL= " + url
        }
        return "RESPONSE FAILED \(requestUrl)\nERROR: \(String(describing: error.errorDescription ?? ""))"
    }
}
