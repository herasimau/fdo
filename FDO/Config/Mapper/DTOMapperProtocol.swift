//
//  DTOMapperProtocol.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

protocol DTODecodableMappable {
    associatedtype Model: Any
    associatedtype Dto: Decodable

    static func dtoToModel(_ dto: Dto) -> Model
}

protocol DTOEncodableMappable {
    associatedtype Model: Any
    associatedtype Dto: Encodable

    static func modelToDto(_ model: Model) -> Dto
}

protocol DTOMappable: DTODecodableMappable, DTOEncodableMappable {}
