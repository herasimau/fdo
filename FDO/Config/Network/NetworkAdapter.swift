//
//  NetworkAdapter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import PromiseKit

// MARK: - NetworkAdapterAPI

/**
 Network Adapter API
 */
public protocol NetworkAdapterAPI: Component {

    /**
     Executes a call to a multipart/form-data service that returns a dictionary.
     - Parameter request : The request.
     - Parameter multipartFormData : The `MultipartFormData`.
     - Returns: A `Promise` that is resolved with the `NSDictionary`.
     */
    func requestFormData(request: NetworkRequest, multipartFormData: @escaping (MultipartFormData) -> Void) -> Promise<NSDictionary>

    /**
     Executes a call to a REST service that returns a DTO.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `Mappable`.
     */
    func requestObject<T: Mappable>(request: NetworkRequest) -> Promise<T>

    /**
     Executes a call to a REST service that returns an array of DTO.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the Array of `Mappable`.
     */
    func requestArray<T: Mappable>(request: NetworkRequest) -> Promise<[T]>

    /**
     Executes a call to a REST service.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved at the end of execution.
     */
    func request(request: NetworkRequest) -> Promise<Void>
    /**
     Executes a call to a REST service that returns a file.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved at the end of execution.
     */
    func requestFile(request: NetworkRequest) -> Promise<FileDTO>

    /**
     Executes a call to a REST service that returns a string.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `String`.
     */
    func requestString(request: NetworkRequest) -> Promise<String>

    /**
     Executes a call to a REST service that returns a Dictionary.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `NSDictionary`.
     */
    func requestDictonary(request: NetworkRequest) -> Promise<NSDictionary>

    /**
     Executes a call to a REST service that returns an array of dictionary.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `NSArray`.
     */
    func requestDictionaryArray(request: NetworkRequest) -> Promise<NSArray>

    /**
     Executes a call to a REST service that returns an array of String.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the Array of `String`.
     */
    func requestStringArray(request: NetworkRequest) -> Promise<[String]>

    /**
     Executes a call to a REST service that download a file.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved at the end of execution.
     */
    func requestDownload(request: NetworkRequest) -> Promise<Void>

    ////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////

    /**
     Executes a call to a REST service that returns a DTO.
     - Parameter request : The request.
     - Returns: A `Promise` that is resolved with the `Decodable`.
     */
    func requestObject<T: Decodable>(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type) -> Promise<T>
    func requestObject<T: Decodable>(request: NetworkCodableRequest) -> Promise<T>

    /**
    Executes a call to a REST service that returns a String.
    - Parameter request : The request.
    - Returns: A `Promise` that is resolved encoding with a String.
    */
    func requestObject(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type) -> Promise<String>
    func requestObject(request: NetworkCodableRequest) -> Promise<String>

    /**
    Executes a call to a REST service that returns a Void promise.
    - Parameter request : The request.
    - Returns: A `Promise` that is resolved with a void promise.
    */
    func requestObject(request: NetworkCodableRequest, responseDecoder: NetworkResponse.Type) -> Promise<Void>
    func requestObject(request: NetworkCodableRequest) -> Promise<Void>

    /**
     Cancel all request
     */
    func cancelAllRequest()
}

// MARK: - NetworkAdapterDelegate
public protocol NetworkAdapterDelegate: class {
    func networkAdapterDidDetectUnauthorized(_ networkAdapter: NetworkAdapterAPI)
    func networkAdapterTryToRefresh(_ networkAdapter: NetworkAdapterAPI, completion: @escaping (Bool) -> Void)
}
