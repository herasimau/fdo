//
//  Completion.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public typealias CustomCompletion<T> = Completion<T, CustomError>

public extension Error {
    func handle<T>(completion: CustomCompletion<T>) {
        guard let networkError = self as? NetworkError else {
            completion(.failure(CustomError.unknown))
            return
        }
        completion(.failure(CustomError(networkError: networkError)))
    }
}
