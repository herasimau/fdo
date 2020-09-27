//
//  Result.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

public typealias Completion<T, E: Error> = (Result<T, E>) -> Void

public extension Result {

    var value: Success? {
        switch self {
        case .success(let res):
            return res
        default:
            return nil
        }
    }

    var error: Failure? {
        switch self {
        case .failure(let err):
            return err
        default:
            return nil
        }
    }
}
