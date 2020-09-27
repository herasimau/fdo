//
//  RefreshAuthDTO.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 19/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

struct RefreshAuthDTO: Decodable {
    let access_token: String
    let refresh_token: String
    let user_id: String
}
