//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public extension DefaultStringInterpolation {
    
    /// Convenient extension for formatting dates using string interpolation.
    ///
    /// Example:
    ///
    /// ```
    /// let date = Date()
    /// let dateFormatter = DateFormatter()
    /// dateFormatter.dateFormat = "yyyy-MM-dd"
    /// print("Today is \(date, dateFormatter)")
    /// ```
    mutating func appendInterpolation(_ value: Date, _ formatter: DateFormatter) {
        appendInterpolation(formatter.string(from: value))
    }
    
    /// Convenient extension for formatting dates using string interpolation.
    ///
    /// Example:
    ///
    /// ```
    /// let date = Date()
    /// let isoFormatter = ISO8601DateFormatter()
    /// print("Today is \(date, isoFormatter)")
    /// ```
    mutating func appendInterpolation(_ value: Date, _ formatter: ISO8601DateFormatter) {
        appendInterpolation(formatter.string(from: value))
    }
    
}
