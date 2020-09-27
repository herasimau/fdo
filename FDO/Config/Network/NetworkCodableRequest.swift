//
//  NetworkCodableRequest.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import Alamofire

public struct NetworkProgress {
    public let totalCount: Int
    public let completedCount: Int
}

public struct MultiPartData {
    public let data: Data
    public let name: String
    public let fileName: String?
    public let mimeType: String?
}

public enum RequestType {

    /// A request to send or receive data
    case data

    /// A file upload task.
    case upload(RequestType.UploadType)

    /// A file download task to a destination.
    case download(destination: URL)

    public enum UploadType {
        /// A file upload task.
        case file(url: URL)

        /// A "multipart/form-data" upload task.
        case multipart(data: [MultiPartData])
    }
}

public class NetworkCodableRequest {
    public let baseUrl: String
    public let path: String
    public let method: HTTPMethod
    public let requestType: RequestType
    public var headers: HTTPHeaders?
    public var authorizationRequired: Bool = true
    public var ignoreNetworkStatus: Bool = false

    // Demo
    public var useDemoMode: Bool = false
    public var demoSuccessFileName: String?
    public var demoFailureFileName: String?
    public var demoFilesBundle: Bundle = Bundle.main
    public var demoWaitingTimeRange: ClosedRange<TimeInterval> = 0.0...0.0
    public var demoSuccessStatusCode: Int = 200
    public var demoFailureStatusCode: Int = 400
    public var demoFailureChance: Double = 0.0

    // progress
    public var progressHandler: ((NetworkProgress) -> Void)?

    // init
    public init(baseUrl: String, path: String, method: HTTPMethod, requestType: RequestType = .data) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.requestType = requestType
    }

    // Parameters
    public var pathParameters: [String: Any] = [:]
    private(set) var urlParameters: [String: Any] = [:]
    private(set) var bodyParameters: Encodable?

    public var parameters: Encodable? {
        didSet {
            switch method {
            case .get, .head, .delete:
                urlParameters = parameters?.dictionary(withEncoder: jsonEncoder) ?? [:]
            default:
                bodyParameters = parameters
            }
        }
    }

    // Encoding
    public var urlParameterEncoding: ParameterEncoding = URLEncoding.default

    public var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.serverDateTimeFormatter)
        return encoder
    }

    // Build Request
    public func buildUrlRequest() throws -> URLRequest {
        let url = try buildURL()

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        // url encoding
        if !urlParameters.isEmpty {
            request = try request.encoded(parameters: urlParameters, parameterEncoding: urlParameterEncoding)
        }

        // body encoding
        if let bodyParams = bodyParameters {
            try encodeBody(request: &request, parameters: bodyParams)
        }
        return request
    }

    public func encodeBody(request: inout URLRequest, parameters: Encodable) throws {
        request = try request.encoded(encodable: parameters, encoder: jsonEncoder)
    }
}

// MARK: Utils
extension NetworkCodableRequest {

    func buildURL() throws -> URL {
        var composedUrl = path.isEmpty ? baseUrl : baseUrl.appending(path)

        // search for "/:" to find the start of a path parameter
        while let paramRange = findNextPathParamPlaceholderRange(in: composedUrl) {
            let paramName = String(composedUrl[composedUrl.index(after: paramRange.lowerBound)..<paramRange.upperBound])
            let param = try findPathParam(with: paramName, in: pathParameters)
            composedUrl.replaceSubrange(paramRange, with: param)
        }
        guard let url = URL(string: composedUrl)
            else { throw NetworkError.badRequestInvalidUrl }
        return url
    }

    private func findNextPathParamPlaceholderRange(in string: String) -> Range<String.Index>? {
        if let startRange = string.range(of: "/:") {
            let semicolonIndex = string.index(after: startRange.lowerBound)
            let searchRange: Range<String.Index> = semicolonIndex..<string.endIndex
            if let endRange = string.range(of: "/", options: String.CompareOptions.caseInsensitive, range: searchRange, locale: nil) {
                return semicolonIndex..<endRange.lowerBound
            } else {
                return semicolonIndex..<string.endIndex
            }
        }
        return nil
    }

    private func findPathParam(with name: String, in parameters: [String: Any]) throws -> String {
        if let param = parameters[name] {
            return "\(param)"
        } else {
            throw NetworkError.badRequestPathParametersNotFound
        }
    }
}

// MARK: Encoding
extension URLRequest {
    mutating func encoded(encodable: Encodable, encoder: JSONEncoder) throws -> URLRequest {
        do {
            let encodable = EncodableWrapper(encodable)
            httpBody = try encoder.encode(encodable)

            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json; charset=UTF-8", forHTTPHeaderField: contentTypeHeaderName)
            }

            return self
        } catch {
            throw NetworkError.badRequestEncoding(error: error)
        }
    }

    func encoded(parameters: [String: Any], parameterEncoding: ParameterEncoding) throws -> URLRequest {
        do {
            return try parameterEncoding.encode(self, with: parameters)
        } catch {
            throw NetworkError.badRequestEncoding(error: error)
        }
    }
}

private struct EncodableWrapper: Encodable {
    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        return dictionary(withEncoder: JSONEncoder())
    }

    func dictionary(withEncoder jsonEncoder: JSONEncoder) -> [String: Any]? {
        guard let data = try? jsonEncoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

// MARK: Print utils
extension NetworkCodableRequest {

    func descriptionFor(request: URLRequest) -> String {
        var string = "REQUEST \(self.method.rawValue) \(String(describing: request.url?.absoluteString ?? ""))\nHEADERS:\(String(describing: self.headers ?? [:])))"
        if !self.urlParameters.isEmpty {
            string.append("\nPARAMETERS:\(self.urlParameters)")
        }
        if let bodyParams = self.bodyParameters {
            string.append("\nBODY PARAMETERS:\(bodyParams)")
        }
        if let httpBody = request.httpBody, let body = String(data: httpBody, encoding: .utf8) {
            string.append("\nBODY:\n\(body)")
        }
        return string
    }
}
