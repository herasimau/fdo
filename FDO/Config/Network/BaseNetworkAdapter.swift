//
//  BaseNetworkAdapter.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import PromiseKit

private class RefreshTokenRetrier: RequestRetrier {

    private var networkAdapter: BaseNetworkAdapter
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []

    init(networkAdapter: BaseNetworkAdapter) {
        self.networkAdapter = networkAdapter
    }

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        guard let response = request.task?.response as? HTTPURLResponse else { return completion(false, 0.0) }
        guard response.statusCode == 403 else { return completion(false, 0.0) }
        guard let delegate = networkAdapter.delegate else { return completion(false, 0.0) }

        requestsToRetry.append(completion)
        if !isRefreshing {
            self.isRefreshing = true
            networkAdapter.tokenRefrehPromise = Promise<Void> { seal in
                delegate.networkAdapterTryToRefresh(networkAdapter) { [weak self] succeeded -> Void in
                    seal.fulfill(())
                    guard let self = self else { return completion(false, 0.0) }
                    self.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    self.requestsToRetry.removeAll()
                    self.isRefreshing = false
                }
            }
        }
    }
}

public class BaseNetworkAdapter: NetworkAdapterAPI {

    // MARK: - Properties

    /**
     Alamofire session manager
     */
    private var sessionManager: SessionManager!
    fileprivate var tokenRefrehPromise: Promise<Void> = .value(())
    private var pendingRequests: [String: Request] = [:]
    public weak var delegate: NetworkAdapterDelegate?

    /**
     Constructor
     */
    init(adapter: RequestAdapter?) {
        sessionManager = SessionManager(configuration: URLSessionConfiguration.default)
        sessionManager.retrier = RefreshTokenRetrier(networkAdapter: self)
        sessionManager.adapter = adapter
    }

    // MARK: - Methods

    /**
     Cancel all request
     */
    public func cancelAllRequest() {
        self.pendingRequests.values.forEach {
            $0.cancel()
        }
        self.pendingRequests.removeAll()
    }

    /**
     Executes a call to a multipart/form-data service that returns a dictionary.
     - Parameter request : The request.
     - Parameter multipartFormData : The `MultipartFormData`.
     - Returns: A `Promise` that is resolved with the `NSDictionary`.
     */
    public func requestFormData(request: NetworkRequest, multipartFormData: @escaping (MultipartFormData) -> Void) -> Promise<NSDictionary> {
        if NetworkNotifier.isOnline {
            return checkTokenValidity(request.authorizationRequired).then { _ -> Promise<NSDictionary> in
                return Promise<NSDictionary> { seal in
                    self.sessionManager.upload(
                        multipartFormData: multipartFormData,
                        to: request.url,
                        headers: request.headers
                    ) { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                if response.response?.statusCode == 200 {
                                    seal.fulfill(response.result.value as? NSDictionary ?? NSDictionary())
                                } else {
                                    seal.reject(self.handleError(response.error, request: response.request, statusCode: response.response?.statusCode, responseData: response.data))
                                }
                            }
                        case .failure(let encodingError):
                            if let err = encodingError as? AFError {
                                let ne = RestErrorDTO()
                                ne.status = err.responseCode
                                ne.message = err.failureReason
                                ne.error = err.errorDescription
                                seal.reject(ne)
                            }
                        }
                    }
                }
            }
        } else {
            return Promise<NSDictionary>(error: self.offlineError())
        }
    }

    /**
     Executes a call to a REST service that returns a DTO.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `Mappable`.
     */
    public func requestObject<T: Mappable>(request: NetworkRequest) -> Promise<T> {
        return self.makeRequestObject(request: request)
    }

    /**
     Executes a call to a REST service that returns an array of DTO.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the Array of `Mappable`.
     */
    public func requestArray<T: Mappable>(request: NetworkRequest) -> Promise<[T]> {
        return self.makeRequestArray(request: request)
    }

    /**
     Executes a call to a REST service that returns an array of String.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the Array of `String`.
     */
    public func requestStringArray(request: NetworkRequest) -> Promise<[String]> {
        return self.makeRequestJSON(request: request)
    }

    /**
     Executes a call to a REST service.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved at the end of execution.
     */
    public func request(request: NetworkRequest) -> Promise<Void> {
        return self.requestString(request: request).done { _ in }
    }

    /**
     Executes a call to a REST service that returns a string.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `String`.
     */
    public func requestString(request: NetworkRequest) -> Promise<String> {
        return self.makeRequestString(request: request)
    }

    /**
     Executes a call to a REST service that returns a Dictionary.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `NSDictionary`.
     */
    public func requestDictonary(request: NetworkRequest) -> Promise<NSDictionary> {
        return self.makeRequestJSON(request: request)
    }

    /**
     Executes a call to a REST service that returns an array of dictionary.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `NSArray`.
     */
    public func requestDictionaryArray(request: NetworkRequest) -> Promise<NSArray> {
        return self.makeRequestJSON(request: request)
    }

    /**
     Executes a call to a REST service that returns a file.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved at the end of execution.
     */
    public func requestFile(request: NetworkRequest) -> Promise<FileDTO> {
        return self.makeRequest(request: request).then { req -> Promise<FileDTO> in
            return Promise<FileDTO> { seal in
                req.responseData { response in
                    self.checkResponse(response: response, seal: seal) { data, _ in
                        let dto = FileDTO()
                        dto.data = data
                        if let header = response.response?.allHeaderFields["Content-Disposition"] as? String {
                            dto.filename = String(header[header.range(of: "filename=")!.upperBound...])
                        }
                        return dto
                    }
                }
            }
        }
    }

    /**
     Executes a call to a REST service that download a file.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved at the end of execution.
     */
    public func requestDownload(request: NetworkRequest) -> Promise<Void> {
        return self.makeDownloadRequest(request: request).then { req -> Promise<Void> in
            return Promise<Void> { seal in
                req.responseData { response in
                    switch response.result {
                    case .success:
                        seal.fulfill(())
                    case .failure(let error):
                        seal.reject(self.handleError(error, request: response.request, statusCode: response.response?.statusCode, responseData: nil))
                    }
                }
            }
        }
    }
}

// MARK: - Make Request
extension BaseNetworkAdapter {
    private func makeRequestString(request: NetworkRequest) -> Promise<String> {
        return self.makeRequest(request: request).then { dataRequest -> Promise<String> in
            return Promise<String> { seal in
                dataRequest.responseString { response in
                    self.checkResponse(response: response, seal: seal) { data, _ in
                        return data
                    }
                }
            }
        }
    }

    private func makeRequestJSON<T>(request: NetworkRequest) -> Promise<T> {
        return self.makeRequest(request: request).then { dataRequest -> Promise<T> in
            return Promise<T> { seal in
                dataRequest.responseJSON { response in
                    self.checkResponse(response: response, seal: seal) { data, _ in
                        return (data as? T)!
                    }
                }
            }
        }
    }

    private func makeRequestObject<T: Mappable>(request: NetworkRequest) -> Promise<T> {
        return self.makeRequest(request: request).then { dataRequest -> Promise<T> in
            return Promise<T> { seal in
                dataRequest.responseObject { (response: DataResponse<T>) in
                    self.checkResponse(response: response, seal: seal) { data, _ in
                        return data
                    }
                }
            }
        }
    }

    private func makeRequestArray<T: Mappable>(request: NetworkRequest) -> Promise<[T]> {
        return self.makeRequest(request: request).then { dataRequest -> Promise<[T]> in
            return Promise<[T]> { seal in
                dataRequest.responseArray { (response: DataResponse<[T]>) in
                    self.checkResponse(response: response, seal: seal) { data, _ in
                        return data
                    }
                }
            }
        }
    }

    private func makeDownloadRequest(request: NetworkRequest) -> Promise<DownloadRequest> {
        if NetworkNotifier.isOnline {
            return Promise<DownloadRequest> { seal in
                let downloadRequest = self.sessionManager.download(
                    request.url,
                    method: request.method,
                    parameters: request.parameters,
                    encoding: request.encoding ?? URLEncoding.default,
                    to: request.downloadDestination)
                if let closureProgressHandler = request.progressHandler {
                    downloadRequest.downloadProgress(closure: closureProgressHandler)
                }
                let uuid = UUID().uuidString
                self.pendingRequests[uuid] = downloadRequest
                downloadRequest.validate().response { response in
                    self.pendingRequests.removeValue(forKey: uuid)
                }
                seal.fulfill(downloadRequest)
            }
        } else {
            return Promise<DownloadRequest>(error: self.offlineError())
        }
    }

    private func makeRequest(request: NetworkRequest) -> Promise<DataRequest> {
        if NetworkNotifier.isOnline {
            return checkTokenValidity(request.authorizationRequired).then { _ -> Promise<DataRequest> in
                return Promise<DataRequest> { seal in
                    let dataRequest = self.sessionManager.request(
                        request.url,
                        method: request.method,
                        parameters: request.parameters,
                        encoding: request.encoding ?? URLEncoding.default,
                        headers: request.headers)
                    let uuid = UUID().uuidString
                    self.pendingRequests[uuid] = dataRequest
                    dataRequest.validate()
                        .response { response in
                            self.pendingRequests.removeValue(forKey: uuid)
                    }
                    seal.fulfill(dataRequest)
                }
            }
        } else {
            return Promise<DataRequest>(error: self.offlineError())
        }

    }

    private func checkResponse<D, T>(response: DataResponse<D>, seal: Resolver<T>, mapping: @escaping (D, DataResponse<D>) -> T) {
        switch response.result {
        case .success(let data):
            let responseMapped = mapping(data, response)
            seal.fulfill(responseMapped)
        case .failure(let error):
            seal.reject(self.handleError(error, request: response.request, statusCode: response.response?.statusCode, responseData: response.data))
        }
    }

    private func checkTokenValidity(_ authorizationRequired: Bool) -> Promise<Void> {
        if authorizationRequired {
            return tokenRefrehPromise
        }
        return .value(())
    }
}

// MARK: - Error Handler
extension BaseNetworkAdapter {
    /**
     Return custom Offline Error
     - Returns:  `RestErrorDTO`
     */
    private func offlineError() -> RestErrorDTO {
        let restError = RestErrorDTO()
        restError.status = 0
        restError.error = "Network Error"
        restError.message = "No internet connection"
        return restError
    }

    /**
     Handle Network Error
     - Parameter error: The request error.
     - Parameter request: Request object.
     - Parameter statusCode: Reponse status code.
     - Parameter responseData: Reponse body.
     - Returns:  `NetworkErrorDTO`
     */
    private func handleError(_ error: Error?, request: URLRequest?, statusCode: Int?, responseData: Data?) -> NetworkErrorDTO {
        var ne: NetworkErrorDTO!
        let logRequest  = self.parseRequest(request: request)

        if let err = error as? URLError {
            ne = parseURLError(err)
        } else if let data = responseData {
            if let json = String(data: data, encoding: String.Encoding.utf8) {
                ne = parseMTDError(json, statusCode: statusCode)
            } else if let afError =  error as? AFError {
                ne = parseAFError(afError, statusCode: statusCode)
            } else {
                ne = unknowError(statusCode: statusCode)
            }
        } else {
            ne = unknowError(statusCode: -1)
        }

        if ne.status == 403, let delegate = self.delegate {
            delegate.networkAdapterDidDetectUnauthorized(self)
        }
        if let stat = ne.status {
            logRequest.response_code = stat
        }
        ne.request = logRequest
        return ne
    }

    private func parseRequest(request: URLRequest?) -> LogRequestDTO {
        let logRequest = LogRequestDTO()
        if let req = request {
            if let url = req.url {
                var urlStr = url.absoluteString
                var components = URLComponents(string: urlStr)
                if components?.queryItems != nil, let idx = components!.queryItems!.firstIndex(where: {$0.name == "page"}) {
                    components!.queryItems!.remove(at: idx)
                    do {
                        urlStr = try components!.asURL().absoluteString
                    } catch {
                        // Ignore
                    }

                }
                logRequest.endpoint = urlStr
            }
            if let method = req.httpMethod {
                logRequest.method = method
            }
            if let body = req.httpBody, let json = String(data: body, encoding: String.Encoding.utf8) {
                logRequest.request_body = json
            }
        }
        return logRequest
    }

    private func parseURLError(_ error: URLError) -> NetworkErrorDTO {
        let restError = RestErrorDTO()
        restError.status = 0
        restError.error = "Network Error"
        switch error.code {
        case URLError.Code.notConnectedToInternet:
            restError.message = "No internet connection"
        case URLError.Code.timedOut:
            restError.message = "Connection timeout"
        case URLError.Code.cancelled:
            restError.message = "Request cancelled"
            restError.status = URLError.Code.cancelled.rawValue
        default:
            restError.message = "Error unknown"
        }
        return restError
    }

    private func parseAFError(_ error: AFError, statusCode: Int?) -> NetworkErrorDTO {
        let restError = RestErrorDTO()
        restError.message = error.errorDescription
        restError.error = error.errorDescription
        restError.status = statusCode
        return restError
    }

    private func parseMTDError(_ json: String, statusCode: Int?) -> NetworkErrorDTO {
        let rest = Mapper<RestErrorDTO>().map(JSONString: json)

        if let restError = rest {
            restError.status = statusCode
            return restError
        } else {
            let restError = RestErrorDTO()
            restError.message = json
            restError.error = json
            restError.status = statusCode
            return restError
        }
    }

    private func unknowError(statusCode: Int?) -> NetworkErrorDTO {
        let restError = RestErrorDTO()
        restError.error = "Network Error"
        restError.message = "Error unknown"
        restError.status = statusCode
        return restError
    }
}

// MARK: Codable
extension BaseNetworkAdapter {

    /**
     Executes a call to a REST service that returns a DTO.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `Decodable`.
     */
    public func requestObject<T: Decodable>(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type) -> Promise<T> {
        return makeRequest(request: request, responseDecoder: responseDecoder).then { response in
            self.checkValidResponseData(response)
        }.then { (response, data) in
            self.decodeResponse(data, response: response)
        }
    }

    public func requestObject<T: Decodable>(request: NetworkCodableRequest) -> Promise<T> {
        return requestObject(request: request, responseDecoder: BaseNetworkResponse.self)
    }

    /**
    Executes a call to a REST service that returns a String.
    - Parameter request : The request.
    - Returns: A `Promise` that is resolved encoding with a String.
    */
    public func requestObject(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type) -> Promise<String> {
        return makeRequest(request: request, responseDecoder: responseDecoder).then { response in
            self.checkValidResponseData(response)
        }.then { (response, data) in
            self.decodeResponse(data, response: response)
        }
    }

    public func requestObject(request: NetworkCodableRequest) -> Promise<String> {
        return requestObject(request: request, responseDecoder: BaseNetworkResponse.self)
    }

    /**
    Executes a call to a REST service that returns a Void promise.
    
    - Parameter request : The request.
    - Returns: A `Promise` that is resolved with a void promise.
    */
    public func requestObject(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type) -> Promise<Void> {
        return makeRequest(request: request, responseDecoder: responseDecoder).then { response -> Promise<Void> in
            switch request.requestType {
            case .download:
                return .value(())
            default:
                return self.checkValidResponseData(response).done {_ in}
            }
        }
    }

    public func requestObject(request: NetworkCodableRequest) -> Promise<Void> {
        return requestObject(request: request, responseDecoder: BaseNetworkResponse.self)
    }
}

// MARK: Execute request
extension BaseNetworkAdapter {
    private func makeRequest(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type) -> Promise<NetworkResponse> {
        return makeNetworkRequest(request: request, responseDecoder: responseDecoder)
    }

    private func makeNetworkRequest(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type) -> Promise<NetworkResponse> {
        if NetworkNotifier.isOnline || request.ignoreNetworkStatus {
            return checkTokenValidity(request.authorizationRequired).then { _ -> Promise<NetworkResponse> in
                return Promise<NetworkResponse> { [weak self] seal in
                    guard let self = self else { return }
                    let uuid = UUID().uuidString
                    let dataRequest = self.executeRequest(request: request, responseDecoder: responseDecoder) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let response):
                            self.pendingRequests.removeValue(forKey: uuid)
                            seal.fulfill(response)
                        case .failure(let error):
                            seal.reject(error)
                        }
                    }
                    if let req = dataRequest {
                        self.pendingRequests[uuid] = req
                    }
                }
            }
        } else {
            return throwError(error: NetworkError.noConnection)
        }
    }

    private func executeRequest(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type, completion: @escaping Completion<NetworkResponse, Error>) -> Request? {
        do {
            switch request.requestType {
            // DATA
            case .data:
                return try executeDataRequest(request, responseDecoder: responseDecoder, completion: completion)
            // DOWNLOAD
            case .download(destination: let url):
                return try executeDownloadRequest(request, url: url, responseDecoder: responseDecoder, completion: completion)
            // UPLOAD
            case .upload(let uploadType):
                switch uploadType {
                case .file(url: let url):
                    return try executeUploadFileRequest(request, url: url, responseDecoder: responseDecoder, completion: completion)
                case .multipart(data: let multipartBodyParts):
                    return try executeUploadMultipartRequest(request, multipartBodyParts: multipartBodyParts, responseDecoder: responseDecoder, completion: completion)
                }
            }
        } catch {
            completion(.failure(error as? NetworkError ?? .unknown))
            return nil
        }
    }

    private func executeDataRequest(_ request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type, completion: @escaping Completion<NetworkResponse, Error>) throws -> Request? {
        let urlRequest = try request.buildUrlRequest()
        let dataRequest = self.sessionManager.request(urlRequest)
        dataRequest.validate().response { dataResp in
            let networkResponse = responseDecoder.init(request: dataResp.request, response: dataResp.response, statusCode: dataResp.response?.statusCode, data: dataResp.data, error: dataResp.error)
            completion(.success(networkResponse))
        }
        return dataRequest
    }

    private func executeDownloadRequest(_ request: NetworkCodableRequest, url: URL, responseDecoder: NetworkResponse.Type, completion: @escaping Completion<NetworkResponse, Error>) throws -> Request? {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (url, [.removePreviousFile, .createIntermediateDirectories])
        }
        let urlRequest = try request.buildUrlRequest()
        let dataRequest = self.sessionManager.download(urlRequest, to: destination)
        if let closureProgressHandler = request.progressHandler {
            let progressHandler: DownloadRequest.ProgressHandler = { progress -> Void in
                let prog = NetworkProgress(totalCount: Int(progress.totalUnitCount), completedCount: Int(progress.completedUnitCount))
                closureProgressHandler(prog)
            }
            dataRequest.downloadProgress(closure: progressHandler)
        }
        dataRequest.validate().response { dataResp in
            let networkResponse = responseDecoder.init(request: dataResp.request, response: dataResp.response, statusCode: dataResp.response?.statusCode, data: nil, error: dataResp.error)
            completion(.success(networkResponse))
        }
        return dataRequest
    }

    private func executeUploadFileRequest(_ request: NetworkCodableRequest, url: URL, responseDecoder: NetworkResponse.Type, completion: @escaping Completion<NetworkResponse, Error>) throws -> Request? {
        let urlRequest = try request.buildUrlRequest()
        let dataRequest = self.sessionManager.upload(url, with: urlRequest)
        dataRequest.validate().response { dataResp in
            let networkResponse = responseDecoder.init(request: dataResp.request, response: dataResp.response, statusCode: dataResp.response?.statusCode, data: nil, error: dataResp.error)
            completion(.success(networkResponse))
        }
        if let closureProgressHandler = request.progressHandler {
            let progressHandler: DownloadRequest.ProgressHandler = { progress -> Void in
                let prog = NetworkProgress(totalCount: Int(progress.totalUnitCount), completedCount: Int(progress.completedUnitCount))
                closureProgressHandler(prog)
            }
            dataRequest.uploadProgress(closure: progressHandler)
        }
        return dataRequest
    }

    private func executeUploadMultipartRequest(_ request: NetworkCodableRequest, multipartBodyParts: [MultiPartData], responseDecoder: NetworkResponse.Type, completion: @escaping Completion<NetworkResponse, Error>) throws -> Request? {
        let urlRequest = try request.buildUrlRequest()
        let multipartFormData: (MultipartFormData) -> Void = { form in
            for bodyPart in multipartBodyParts {
                if let mimeType = bodyPart.mimeType {
                    if let fileName = bodyPart.fileName {
                        form.append(bodyPart.data, withName: bodyPart.name, fileName: fileName, mimeType: mimeType)
                    } else {
                        form.append(bodyPart.data, withName: bodyPart.name, mimeType: mimeType)
                    }
                } else {
                    form.append(bodyPart.data, withName: bodyPart.name)
                }
            }
        }
        self.sessionManager.upload(multipartFormData: multipartFormData, with: urlRequest) { result in
            switch result {
            case .success(let upload, _, _):
                upload.response { dataResp in
                    let networkResponse = responseDecoder.init(request: dataResp.request, response: dataResp.response, statusCode: dataResp.response?.statusCode, data: dataResp.data, error: dataResp.error)
                    completion(.success(networkResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return nil
    }
}

// MARK: Decoding
extension BaseNetworkAdapter {

    private func checkValidResponse(_ response: NetworkResponse) -> Promise<NetworkResponse> {
        // check errors
        guard response.error == nil else {
            let networkError: NetworkError = errorForResponse(response)
            return throwError(error: networkError, response: response)
        }

        // empty response
        if !response.isDemo && response.response == nil {
            return throwError(error: NetworkError.missingResponse, response: response)
        }

        return Promise.value(response)
    }

    private func checkValidResponseData(_ response: NetworkResponse) -> Promise<(NetworkResponse, Data)> {

        return checkValidResponse(response).then { [weak self] resp -> Promise<(NetworkResponse, Data)> in
            guard let self = self else { return Promise(error: NetworkError.unknown) }
            guard let data = resp.data else {
                return self.throwError(error: NetworkError.missingResponse, response: response)
            }
            return Promise.value((response, data))
        }
    }

    private func decodeResponse<T: Decodable>(_ data: Data, response: NetworkResponse) -> Promise<T> {
        let result: Swift.Result<T, NetworkError> = response.decode()
        switch result {
        case .success(let decodedObject):
            return Promise.value(decodedObject)
        case .failure(let error):
            return throwError(error: error, response: response)
        }
    }

    private func decodeResponse(_ data: Data, response: NetworkResponse) -> Promise<String> {
        guard let string = String(data: data, encoding: .utf8) else {
            let error = NSError(domain: "Decoding", code: 0, userInfo: nil)
            return throwError(error: NetworkError.decoding(error: error), response: response)
        }
        return Promise.value(string)
    }
}

// MARK: Error Management
extension BaseNetworkAdapter {

    private func errorForResponse(_ response: NetworkResponse) -> NetworkError {
        guard response.statusCode != 403 else { return NetworkError.unauthorized }

        // network errors
        if let err = response.error as? URLError {
            switch err.code {
            case URLError.Code.notConnectedToInternet:
                return .noConnection
            case URLError.Code.timedOut:
                return .timeout
            case URLError.Code.cancelled:
                return .cancelled
            default:
                return .unknown
            }
        }
        return response.decodeError()
    }

    private func throwError<T>(error: NetworkError, response: NetworkResponse? = nil) -> Promise<T> {
        switch error {
        case .unauthorized:
            delegate?.networkAdapterDidDetectUnauthorized(self)
        default:
            break
        }
        return Promise<T>(error: error)
    }
}
