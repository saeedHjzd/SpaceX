//
//  DateFormatterExtension.swift
//  SpaceX Lauches
//
//  Created by Saeed on 4/7/1402 AP.
//

import Foundation

extension DateFormatter {
    static func localizedDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
}



