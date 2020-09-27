//
//  DateFormatter.swift
//  FDO_TUSUR
//
//  Created by Leanid Herasimau on 18/04/2020.
//  Copyright © 2020 Tusur. All rights reserved.
//

import Foundation

extension DateFormatter {

    // yyyy-MM-dd
    public static var serverDateFormatter: DateFormatter {
        return buildServerDateFormatter(format: Constants.Format.serverDateFormat)
    }

    // yyyy-MM-dd'T'HH:mm:ss
    public static var serverDateTimeFormatter: DateFormatter {
        return buildServerDateFormatter(format: Constants.Format.serverDateTimeFormat)
    }

    // yyyy-MM-dd'T'HH:mm:ss.SSSZ
    public static var serverDateTimeTimestampFormatter: DateFormatter {
        return buildServerDateFormatter(format: Constants.Format.serverDateTimeTimestamp)
    }

    // HH:mm:ss
    public static var serverTimeFormatter: DateFormatter {
        return buildServerDateFormatter(format: Constants.Format.serverTimeFormat)
    }

    // yyyy-MM-dd'T'HH:mm:ssXXX
    public static var serverGoogleFormatter: DateFormatter {
        return buildServerDateFormatter(format: Constants.Format.serverGoogleFormat)
    }
}

// MARK: Utils
extension DateFormatter {

    private static func buildServerDateFormatter(format: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  format
        return dateFormatter
    }
}
