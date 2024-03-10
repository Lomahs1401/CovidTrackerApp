//
//  NumberFormatter.swift
//  CovidTracker
//
//  Created by Le Hoang Long on 10/03/2024.
//

import Foundation

extension NumberFormatter {
    static let prettyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .default
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        formatter.locale = .current
        return formatter
    }()
}
