//
//  UnauthenticatedNetworkAdapter.swift
//  fdo
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

// MARK: - UnauthenticatedNetworkAdapter

/*  Use this network adapter for requests that are not authenticated
    (without authentication header fields) and that don't require 403 managament
 */
public class UnauthenticatedNetworkAdapter: BaseNetworkAdapter {

    // MARK: - Singleton
    public static var shared = UnauthenticatedNetworkAdapter(adapter: nil)
}
